riot.tag2('rockauth-forgot-password', '<rocketmade-forgot-password name="{name}"></rocketmade-forgot-password>', '', '', function(opts) {
    (function() {
      this.name = this.opts.name || "forgot-password";

      rocketmade.on(this.name + ":submit", (function(_this) {
        return function(data) {
          return rockauth.forgot_password(data.email).then(function(response) {
            console.log(response.flash());
            return rockauth.trigger(_this.name + ":pass", response);
          })["catch"](function(response) {
            console.log(response.flash());
            return rockauth.trigger(_this.name + ":fail", response);
          });
        };
      })(this));

      rockauth.on(this.name + ":fail", (function(_this) {
        return function(response) {
          return rocketmade.trigger(_this.name + ":errors", response.validation_errors());
        };
      })(this));

    }).call(this);
}, '{ }');

riot.tag2('rockauth-login', '<rocketmade-login name="{name}" show_forgot="{show_forgot}"></rocketmade-login>', '', '', function(opts) {
    (function() {
      this.name = this.opts.name || "rockauth:login";

      this.show_forgot = this.opts.show_forgot === "" || this.opts.show_forgot || false;

      rocketmade.on(this.name + ":submit", (function(_this) {
        return function(data) {
          return rockauth.authenticate_with_password(data).then(function(response) {
            return rockauth.trigger(_this.name + ":pass", response);
          })["catch"](function(response) {
            return rockauth.trigger(_this.name + ":fail", response);
          });
        };
      })(this));

      rockauth.on(this.name + ":fail", (function(_this) {
        return function(response) {
          console.log(response.flash());
          return rocketmade.trigger(_this.name + ":errors", response.validation_errors());
        };
      })(this));

      rocketmade.on("forgot-password:clicked", (function(_this) {
        return function() {
          return rockauth.trigger(_this.name + ":forgot-password");
        };
      })(this));

    }).call(this);
}, '{ }');

riot.tag2('rockauth-reset-password', '<rocketmade-center> <rocketmade-form name="{parent.name}"> <rocketmade-input name="password" type="password" placeholder="Password" require="require"></rocketmade-input> <rocketmade-input name="confirm_password" type="password" placeholder="Confirm Password" require="require"></rocketmade-input> <rocketmade-submit label="Change Password"></rocketmade-submit> </rocketmade-form> </rocketmade-center>', 'rockauth-reset-password rocketmade-form,[riot-tag="rockauth-reset-password"] rocketmade-form { display: block; margin: auto; padding: 3em; max-width: 30rem; text-align: left; }', '', function(opts) {
    (function() {
      this.name = this.opts.name || "reset-password";

      rocketmade.on(this.name + ":submit", (function(_this) {
        return function(data) {
          if (data.password !== data.confirm_password) {
            rocketmade.trigger(_this.name + ":errors", {
              confirm_password: "Passwords must match."
            });
            return;
          }
          return rockauth.reset_password({
            reset_token: riot.route.query().token,
            new_password: data.password
          }).then(function(response) {
            console.log(response.flash());
            return rockauth.trigger(_this.name + ":success", response);
          })["catch"](function(response) {
            console.log(response.flash());
            rockauth.trigger(_this.name + ":failure", response);
            return rocketmade.trigger(_this.name + ":errors", response.validation_errors());
          });
        };
      })(this));

    }).call(this);
}, '{ }');

riot.tag2('rockauth-test', '<rocketmade-app> <rockauth-login></rockauth-login> </rocketmade-app>', '', '', function(opts) {
    (function() {
      rockauth.url('http://localhost:3010/api');

      rockauth.client_id('jkmCq3jukIA16uQyAUVWkA');

      rockauth.client_secret('rKrbQSqUWgWyMRXN2PJQeHDP0E3KzRJRAasKSoI2Yvw');

    }).call(this);
});
