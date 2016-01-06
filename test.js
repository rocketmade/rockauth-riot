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
      test.equal(errors.email, "We don't recognize this email.", 'email error message');
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
      test.equal(errors.password, "Password is incorrect.", 'password error message');
      return test.end();
    });
  });

}).call(this);
