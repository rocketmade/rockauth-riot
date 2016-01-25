'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _stampit = require('stampit');

var _stampit2 = _interopRequireDefault(_stampit);

var _rockHttpClient = require('@rocketmade/rock-http-client');

var _rockHttpClient2 = _interopRequireDefault(_rockHttpClient);

var _cookiesJs = require('cookies-js');

var _cookiesJs2 = _interopRequireDefault(_cookiesJs);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var cookieStrategy = (0, _stampit2.default)().init(function () {
  var storage = (0, _cookiesJs2.default)(window);
  var domain = undefined;
  /* http://jsfiddle.net/zEwsP/4/ */
  this.get = function (key) {
    return storage.get(key);
  };
  this.set = function (key, value) {
    return storage.set(key, value);
  };
  this.expire = function (key) {
    return storage.expire(key);
  };
});

var localStorageStrategy = (0, _stampit2.default)().init(function () {
  this.get = function (key) {};
  this.set = function (key, value) {};
  this.expire = function (key) {};
});

/**
 * @param {String} url
 * @param {String} clientId
 * @param {String} clientSecret
 * */
exports.default = (0, _stampit2.default)().init(function () {
  var _this = this;

  var rootUrl = this.url || this.rootUrl;
  var clientId = this.clientId;
  var clientSecret = this.clientSecret;
  var storage = this.cookies ? cookieStrategy() : localStorageStrategy();

  var namespaced = function namespaced(key) {
    return 'rockauth:' + key;
  };

  var buildUrl = function buildUrl(path) {
    return '' + rootUrl + path;
  };

  this.httpClient = (0, _rockHttpClient2.default)({ fetch: fetch });

  this.authentication = function (value) {
    if (value) {
      storage.set(namespaced('authentication'), value);
      _this.token(value.token);
    }
    return storage.get(namespaced('authentication'));
  };
  this.user = function (value) {
    if (value) {
      storage.set(namespaced('user', value));
    }
    return storage.get(namespaced('user'));
  };
  this.token = function (value) {
    if (value) {
      storage.set(namespaced('token'), value);
    }
    return storage.get(namespaced('token'));
  };
  this.isAuthenticated = function () {
    return !!_this.token();
  };
  this.secureResource = function (self) {
    var headers = {
      Authorization: 'bearer ' + _this.token()
    };
    return _this.httpClient({ self: self }, { headers: headers });
  };

  this.logout = function () {
    return _this.secureResource(buildUrl('/authentications')).delete().then(function (res) {
      _this.storage.expire(namespaced('token'));
      return res;
    });
  };
  this.forgotPassword = function (username) {
    return _this.secureResource(buildUrl('/authentications')).post({ data: { username: username } });
  };
  this.authenticateWithPassword = function (_ref) {
    var username = _ref.username;
    var password = _ref.password;

    var data = {
      username: username,
      password: password,
      auth_type: 'password',
      client_id: clientId,
      client_secret: clientSecret
    };

    return _this.secureResource(buildUrl('/authentications')).post({ data: data }).then(function (resource) {
      throw new Error('not implemented');
      //this.authentication(resource.authentications[0])
      //this.user()
    });
  };
});