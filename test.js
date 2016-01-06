(function() {
  var browser, nightmare, tape,
    slice = [].slice;

  tape = require('tape');

  nightmare = require('joseph/nightmare');

  browser = nightmare();

  tape.onFinish(function() {
    return browser.end(function() {});
  });

  this.ui = function(label, code) {
    return tape(label, function(test) {
      var key, scope, value;
      scope = {
        test: function(code) {
          return browser.run(function() {
            var args, error;
            error = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
            if (error) {
              test.fail(error);
              test.end();
              return;
            }
            return code.call.apply(code, [test].concat(slice.call(args)));
          });
        }
      };
      for (key in browser) {
        value = browser[key];
        scope[key] = value;
      }
      return code.call(scope, test);
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

  this.ui("rockauth.url(value)", function() {
    this.to('/');
    this.evaluate(function() {
      rockauth.url('http://url');
      return rockauth.url();
    });
    return this.test(function(value) {
      this.equal(value, 'http://url', 'set / get value');
      return this.end();
    });
  });

  this.ui("rockauth.id(value)", function() {
    this.to('/');
    this.evaluate(function() {
      rockauth.id('identifier');
      return rockauth.id();
    });
    return this.test(function(value) {
      this.equal(value, 'identifier', 'set / get value');
      return this.end();
    });
  });

  this.ui("rockauth.secret(value)", function() {
    this.to('/');
    this.evaluate(function() {
      rockauth.secret('secret');
      return rockauth.secret();
    });
    return this.test(function(value) {
      this.equal(value, 'secret', 'set / get value');
      return this.end();
    });
  });

  this.ui("rockauth.user(value)", function() {
    this.to('/');
    this.evaluate(function() {
      rockauth.user({
        id: 1,
        email: "mitch@rocketmade.com"
      });
      return rockauth.user();
    });
    return this.test(function(value) {
      this.deepLooseEqual(value, {
        id: 1,
        email: "mitch@rocketmade.com"
      }, 'set / get value');
      return this.end();
    });
  });

  this.ui("rockauth.token(value)", function() {
    this.to('/');
    this.evaluate(function() {
      rockauth.token('token');
      return rockauth.token();
    });
    return this.test(function(value) {
      this.equal(value, 'token', 'set / get value');
      return this.end();
    });
  });

  this.ui("rockauth.session(value)", function() {
    this.to('/');
    this.evaluate(function() {
      rockauth.session(JSON.parse('{\"id\":5,\"token\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIxMTQzMTAsImV4cCI6MTQ4MzY1MDMxMCwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoic1dxMTdUeURLaDk5TnJSdXE0TXZQeVQvSFJoMzFsQlIifQ.ihRqi8bIF7ZIUaFbP4RG0xcWuzayFw4GLDa9mK2d9Mk\",\"token_id\":\"sWq17TyDKh99NrRuq4MvPyT/HRh31lBR\",\"expiration\":1483650310,\"client_version\":null,\"device_identifier\":null,\"device_os\":null,\"device_os_version\":null,\"device_description\":null,\"user\":{\"id\":1,\"email\":\"mitch@rocketmade.com\",\"first_name\":\"Mitch\",\"last_name\":\"Thompson\",\"provider_authentications\":[]},\"provider_authentication\":null}'));
      return {
        session: rockauth.session(),
        user: rockauth.user(),
        token: rockauth.token()
      };
    });
    return this.test(function(object) {
      this.equal(object.session.id, 5, 'sets session id');
      this.equal(object.session.token_id, 'sWq17TyDKh99NrRuq4MvPyT/HRh31lBR', 'sets session token id');
      this.equal(object.session.expiration, 1483650310, 'sets session token id');
      this.equal(object.user.id, 1, 'sets user id');
      this.equal(object.user.email, 'mitch@rocketmade.com', 'sets user email');
      this.equal(object.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIxMTQzMTAsImV4cCI6MTQ4MzY1MDMxMCwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoic1dxMTdUeURLaDk5TnJSdXE0TXZQeVQvSFJoMzFsQlIifQ.ihRqi8bIF7ZIUaFbP4RG0xcWuzayFw4GLDa9mK2d9Mk", "sets token");
      return this.end();
    });
  });

  this.ui("setup", function() {
    this.to();
    return this.test(function() {
      return this.end();
    });
  });

  this.ui("rockauth.authenticate_with_password(opts) [pass]", function(test) {
    return this.evaluate(function(callback) {
      return rockauth.authenticate_with_password({
        email: "mitch@rocketmade.com",
        password: "password"
      }).then(function(data) {
        return callback(null, data);
      });
    }).then(function(json) {
      var user;
      user = json.user;
      test.ok(json.token, 'token ok');
      test.ok(json.expiration, 'expiration ok');
      test.equal(user.id, 1, 'user id correct');
      test.equal(user.email, "mitch@rocketmade.com", 'email correct');
      test.equal(user.first_name, "Mitch", 'user first name correct');
      test.equal(user.last_name, "Thompson", 'user last name correct');
      return test.end();
    });
  });

  this.ui("rockauth.authenticate_with_password(opts) [fail no email]", function(test) {
    return this.evaluate(function(callback) {
      return rockauth.authenticate_with_password({
        email: "bad@rocketmade.com",
        password: "password"
      })["catch"](function(error) {
        return callback(error);
      });
    }).then(null, function(errors) {
      test.deepLooseEqual(errors, {
        email: "Invalid credentials."
      }, 'password error message');
      return test.end();
    });
  });

  this.ui("rockauth.authenticate_with_password(opts) [fail wrong password]", function(test) {
    return this.evaluate(function(callback) {
      return rockauth.authenticate_with_password({
        email: "mitch@rocketmade.com",
        password: "bad"
      })["catch"](function(error) {
        return callback(error);
      });
    }).then(null, function(errors) {
      test.deepLooseEqual(errors, {
        email: "Invalid credentials."
      }, 'password error message');
      return test.end();
    });
  });

}).call(this);
