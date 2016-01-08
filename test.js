(function() {
  var api, browser, nightmare, tape,
    slice = [].slice;

  tape = require('tape');

  nightmare = require('joseph/nightmare');

  browser = nightmare();

  api = require('./api.json');

  tape.onFinish(function() {
    return browser.end(function() {});
  });

  browser.on('console', function() {
    var args, type;
    type = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    return console.log.apply(console, ["<console>"].concat(slice.call(args)));
  });

  browser.on('page', function() {
    return console.log.apply(console, ["<page>"].concat(slice.call(arguments)));
  });

  this.test = function(label, code) {
    return tape(label, function(test) {
      browser.then = function(code) {
        return browser.run(function() {
          var args, error;
          error = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
          if (!error) {
            return code.call.apply(code, [test].concat(slice.call(args)));
          } else {
            test.fail(error);
            return test.end();
          }
        });
      };
      browser["catch"] = function(code) {
        return browser.run(function() {
          var args, error;
          error = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
          if (error) {
            return code.call(test, error);
          }
        });
      };
      return code.call(browser, test);
    });
  };

  this.helper = function(name, code) {
    return browser[name] = code.bind(browser);
  };

  this.helper('to', function(path) {
    if (path == null) {
      path = '';
    }
    return this.goto("http://localhost:3010" + path);
  });

  browser.to();

  this.test("rockauth.url(value)", function() {
    this.evaluate(function() {
      rockauth.url('http://url');
      return rockauth.url();
    });
    return this.then(function(value) {
      this.equal(value, 'http://url', 'set / get value');
      return this.end();
    });
  });

  this.test("rockauth.client_id(value)", function() {
    this.evaluate(function() {
      rockauth.client_id('identifier');
      return rockauth.client_id();
    });
    return this.then(function(value) {
      this.equal(value, 'identifier', 'set / get value');
      return this.end();
    });
  });

  this.test("rockauth.client_secret(value)", function() {
    this.evaluate(function() {
      rockauth.client_secret('secret');
      return rockauth.client_secret();
    });
    return this.then(function(value) {
      this.equal(value, 'secret', 'set / get value');
      return this.end();
    });
  });

  this.test("rockauth.user(value)", function() {
    this.evaluate(function() {
      rockauth.user({
        id: 1,
        email: "mitch@rocketmade.com"
      });
      return rockauth.user();
    });
    return this.then(function(value) {
      this.deepLooseEqual(value, {
        id: 1,
        email: "mitch@rocketmade.com"
      }, 'set / get value');
      return this.end();
    });
  });

  this.test("rockauth.token(value)", function() {
    this.evaluate(function() {
      rockauth.token('token');
      return rockauth.token();
    });
    return this.then(function(value) {
      this.equal(value, 'token', 'set / get value');
      return this.end();
    });
  });

  this.test("rockauth.session(value)", function() {
    this.evaluate(function() {
      rockauth.session(JSON.parse('{\"id\":5,\"token\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIxMTQzMTAsImV4cCI6MTQ4MzY1MDMxMCwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoic1dxMTdUeURLaDk5TnJSdXE0TXZQeVQvSFJoMzFsQlIifQ.ihRqi8bIF7ZIUaFbP4RG0xcWuzayFw4GLDa9mK2d9Mk\",\"token_id\":\"sWq17TyDKh99NrRuq4MvPyT/HRh31lBR\",\"expiration\":1483650310,\"client_version\":null,\"device_identifier\":null,\"device_os\":null,\"device_os_version\":null,\"device_description\":null,\"user\":{\"id\":1,\"email\":\"mitch@rocketmade.com\",\"first_name\":\"Mitch\",\"last_name\":\"Thompson\",\"provider_authentications\":[]},\"provider_authentication\":null}'));
      return {
        session: rockauth.session(),
        user: rockauth.user(),
        token: rockauth.token()
      };
    });
    return this.then(function(object) {
      this.equal(object.session.id, 5, 'sets session id');
      this.equal(object.session.token_id, 'sWq17TyDKh99NrRuq4MvPyT/HRh31lBR', 'sets session token id');
      this.equal(object.session.expiration, 1483650310, 'sets session token id');
      this.equal(object.user.id, 1, 'sets user id');
      this.equal(object.user.email, 'mitch@rocketmade.com', 'sets user email');
      this.equal(object.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIxMTQzMTAsImV4cCI6MTQ4MzY1MDMxMCwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoic1dxMTdUeURLaDk5TnJSdXE0TXZQeVQvSFJoMzFsQlIifQ.ihRqi8bIF7ZIUaFbP4RG0xcWuzayFw4GLDa9mK2d9Mk", "sets token");
      return this.end();
    });
  });

  this.test("rockauth.authenticate_with_password(opts) [pass]", function() {
    this.to();
    this.evaluate(function(callback) {
      return rockauth.authenticate_with_password({
        email: "mitch@rocketmade.com",
        password: "password"
      }).then(function(data) {
        return callback(null, data);
      });
    });
    return this.then(function(json) {
      this.deepLooseEqual(json, api.authentications.create.pass, 'json response');
      return this.end();
    });
  });

  this.test("rockauth.authenticate_with_password(opts) [fail]", function() {
    this.evaluate(function(callback) {
      return rockauth.authenticate_with_password({
        email: "mitch@rocketmade.com",
        password: "bad"
      })["catch"](function(error) {
        return callback(error);
      });
    });
    return this["catch"](function(error) {
      this.deepLooseEqual(error, api.authentications.create.fail, 'json response');
      return this.end();
    });
  });

}).call(this);
