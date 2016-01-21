<rockauth-forgot-password>
  <script>
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
  </script>
  <rocketmade-forgot-password name="{ name }"></rocketmade-forgot-password>
</rockauth-forgot-password>
