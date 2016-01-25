
(function(tagger) {
  if (typeof define === 'function' && define.amd) {
    define(function(require, exports, module) { tagger(require('riot'), require, exports, module)})
  } else if (typeof module !== 'undefined' && typeof module.exports !== 'undefined') {
    tagger(require('riot'), require, exports, module)
  } else {
    tagger(window.riot)
  }
})(function(riot, require, exports, module) {
riot.tag2('rockauth-forgot-password', '<rocketmade-forgot-password name="{name}"></rocketmade-forgot-password>', '', '', function(opts) {
'use strict';

var _rockAuth = require('./rock-auth.js');

var _rockAuth2 = _interopRequireDefault(_rockAuth);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

(function () {
  this.mixin('eventable');
  this.name = this.opts.name || "forgot-password";

  this.events.on(this.name + ":submit", function (_this) {
    return function (data) {
      return _rockAuth2.default.forgotPassword(data.email).then(function (response) {
        console.log(response.flash());
        return this.events.trigger(_this.name + ":pass", response);
      })["catch"](function (response) {
        console.log(response.flash());
        return this.events.trigger(_this.name + ":fail", response);
      });
    };
  }(this));

  this.events.on(this.name + ":fail", function (_this) {
    return function (response) {
      return this.events.trigger(_this.name + ":errors", response.validation_errors());
    };
  }(this));
}).call(this);
}, '{ }');

riot.tag2('rockauth-login', '<rocketmade-login name="{name}" show_forgot="{show_forgot}"></rocketmade-login>', '', '', function(opts) {
'use strict';

var _rockAuth = require('./rock-auth.js');

var _rockAuth2 = _interopRequireDefault(_rockAuth);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

this.mixin('eventable')(function () {
  this.name = this.opts.name || "rockauth:login";

  this.show_forgot = this.opts.show_forgot === "" || this.opts.show_forgot || false;

  this.events.on(this.name + ":submit", function (_this) {
    return function (data) {
      return _rockAuth2.default.authenticateWithPassword(data).then(function (response) {
        return this.events.trigger(_this.name + ":pass", response);
      })["catch"](function (response) {
        return this.events.trigger(_this.name + ":fail", response);
      });
    };
  }(this));

  this.events.on(this.name + ":fail", function (_this) {
    return function (response) {
      console.log(response.flash());
      return this.events.trigger(_this.name + ":errors", response.validation_errors());
    };
  }(this));

  this.events.on("forgot-password:clicked", function (_this) {
    return function () {
      return this.events.trigger(_this.name + ":forgot-password");
    };
  }(this));
}).call(this);
}, '{ }');

riot.tag2('rockauth-reset-password', '<rocketmade-center> <rocketmade-form name="{parent.name}"> <rocketmade-input name="password" type="password" placeholder="Password" require="require"></rocketmade-input> <rocketmade-input name="confirm_password" type="password" placeholder="Confirm Password" require="require"></rocketmade-input> <rocketmade-submit label="Change Password"></rocketmade-submit> </rocketmade-form> </rocketmade-center>', 'rockauth-reset-password rocketmade-form,[riot-tag="rockauth-reset-password"] rocketmade-form { display: block; margin: auto; padding: 3em; max-width: 30rem; text-align: left; }', '', function(opts) {
'use strict';

var _rockAuth = require('rock-auth.js');

var _rockAuth2 = _interopRequireDefault(_rockAuth);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

(function () {
  this.mixin('eventable');
  this.name = this.opts.name || "reset-password";

  this.events.on(this.name + ":submit", function (_this) {
    return function (data) {
      if (data.password !== data.confirm_password) {
        this.events.trigger(_this.name + ":errors", {
          confirm_password: "Passwords must match."
        });
        return;
      }
      return _rockAuth2.default.resetPassword({
        reset_token: riot.route.query().token,
        new_password: data.password
      }).then(function (response) {
        console.log(response.flash());
        return this.events.trigger(_this.name + ":success", response);
      })["catch"](function (response) {
        console.log(response.flash());
        this.events.trigger(_this.name + ":failure", response);
        return this.events.trigger(_this.name + ":errors", response.validation_errors());
      });
    };
  }(this));
}).call(this);
}, '{ }');

riot.tag2('rockauth-test', '<rocketmade-app> <rockauth-login></rockauth-login> </rocketmade-app>', '', '', function(opts) {
'use strict';

(function () {
  rockauth.url('http://localhost:3010/api');

  rockauth.client_id('jkmCq3jukIA16uQyAUVWkA');

  rockauth.client_secret('rKrbQSqUWgWyMRXN2PJQeHDP0E3KzRJRAasKSoI2Yvw');
}).call(this);
});
});