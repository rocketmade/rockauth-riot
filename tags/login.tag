<rockauth-login>
  <script>
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
  </script>
  <rocketmade-login name="{name}" show_forgot="{ show_forgot }"></rocketmade-login>
</rockauth-login>
