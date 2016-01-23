<rockauth-forgot-password>
  <script>
    import rockauth from './rock-auth.js'
    (function() {
      this.mixin('eventable')
      this.name = this.opts.name || "forgot-password";

      this.events.on(this.name + ":submit", (function(_this) {
        return function(data) {
          return rockauth.forgotPassword(data.email).then(function(response) {
            console.log(response.flash());
            return this.events.trigger(_this.name + ":pass", response);
          })["catch"](function(response) {
            console.log(response.flash());
            return this.events.trigger(_this.name + ":fail", response);
          });
        };
      })(this));

      this.events.on(this.name + ":fail", (function(_this) {
        return function(response) {
          return this.events.trigger(_this.name + ":errors", response.validation_errors());
        };
      })(this));

    }).call(this);
  </script>
  <rocketmade-forgot-password name="{ name }"></rocketmade-forgot-password>
</rockauth-forgot-password>
