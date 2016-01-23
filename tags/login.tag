<rockauth-login>
  <script>
    import rockauth from './rock-auth.js'
    this.mixin('eventable')
    (function() {
      this.name = this.opts.name || "rockauth:login";

      this.show_forgot = this.opts.show_forgot === "" || this.opts.show_forgot || false;

      this.events.on(this.name + ":submit", (function(_this) {
        return function(data) {
          return rockauth.authenticateWithPassword(data).then(function(response) {
            return this.events.trigger(_this.name + ":pass", response);
          })["catch"](function(response) {
            return this.events.trigger(_this.name + ":fail", response);
          });
        };
      })(this));

      this.events.on(this.name + ":fail", (function(_this) {
        return function(response) {
          console.log(response.flash());
          return this.events.trigger(_this.name + ":errors", response.validation_errors());
        };
      })(this));

      this.events.on("forgot-password:clicked", (function(_this) {
        return function() {
          return this.events.trigger(_this.name + ":forgot-password");
        };
      })(this));

    }).call(this);
  </script>
  <rocketmade-login name="{name}" show_forgot="{ show_forgot }"></rocketmade-login>
</rockauth-login>
