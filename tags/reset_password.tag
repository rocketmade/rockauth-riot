<rockauth-reset-password>
  <!-- JS-->
  <script>
    import rockauth from 'rock-auth.js'
    (function() {
      this.mixin('eventable')
      this.name = this.opts.name || "reset-password";

      this.events.on(this.name + ":submit", (function(_this) {
        return function(data) {
          if (data.password !== data.confirm_password) {
            this.events.trigger(_this.name + ":errors", {
              confirm_password: "Passwords must match."
            });
            return;
          }
          return rockauth.resetPassword({
            reset_token: riot.route.query().token,
            new_password: data.password
          }).then(function(response) {
            console.log(response.flash());
            return this.events.trigger(_this.name + ":success", response);
          })["catch"](function(response) {
            console.log(response.flash());
            this.events.trigger(_this.name + ":failure", response);
            return this.events.trigger(_this.name + ":errors", response.validation_errors());
          });
        };
      })(this));

    }).call(this);
  </script>
  <!-- HTML-->
  <rocketmade-center>
    <rocketmade-form name="{parent.name}">
      <rocketmade-input name="password" type="password" placeholder="Password" require="require"></rocketmade-input>
      <rocketmade-input name="confirm_password" type="password" placeholder="Confirm Password" require="require"></rocketmade-input>
      <rocketmade-submit label="Change Password"></rocketmade-submit>
    </rocketmade-form>
  </rocketmade-center>
  <!-- CSS-->
  <style scoped="scoped">
    rocketmade-form {
      display: block;
      margin: auto;
      padding: 3em;
      max-width: 30rem;
      text-align: left;
    }
  </style>
</rockauth-reset-password>
