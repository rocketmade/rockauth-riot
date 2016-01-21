<rockauth-reset-password>
  <!-- JS-->
  <script>
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
