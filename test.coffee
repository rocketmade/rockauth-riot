# REQUIRE

tape      = require 'tape'
nightmare = require 'joseph/nightmare'
browser   = nightmare()

# CONFIG

tape.onFinish ->
  browser.end ->

# CORE

@ui = (label, code) ->
  tape label, (test) ->
    scope =
      test: (code) ->
        browser.run (error, args...) ->
          if error
            test.fail error
            test.end()
            return
          code.call test, args...
    for key, value of browser
      scope[key] = value
    code.call scope, test

@helper = (name, code) ->
  browser[name] = code.bind browser

# HELPERS

@helper 'to', (path = '') ->
  @goto "http://localhost:3010#{path}"

# ROCKAUTH

@ui "setup", ->
  @to()
  @test ->
    @end()

@ui "rockauth.authenticate(opts) [pass]", (test) ->
  @evaluate (callback) ->
    rockauth.authenticate
      email: "mitch@rocketmade.com"
      password: "password"
    .then (data) ->
      callback null, data
  .then (json) ->
    user = json.user
    test.ok json.token, 'token ok'
    test.ok json.expiration, 'expiration ok'
    test.equal user.id, 1, 'user id correct'
    test.equal user.email, "mitch@rocketmade.com", 'email correct'
    test.equal user.first_name, "Mitch", 'user first name correct'
    test.equal user.last_name, "Thompson", 'user last name correct'
    test.end()

@ui "rockauth.authenticate(opts) [fail no email]", (test) ->
  @evaluate (callback) ->
    rockauth.authenticate
      email: "bad@rocketmade.com"
      password: "password"
    .catch (error) ->
      callback error
  .then null, (errors) ->
    test.equal errors.email, "We don't recognize this email.", 'email error message'
    test.end()

@ui "rockauth.authenticate(opts) [fail wrong password]", (test) ->
  @evaluate (callback) ->
    rockauth.authenticate
      email: "mitch@rocketmade.com"
      password: "bad"
    .catch (error) ->
      callback error
  .then null, (errors) ->
    test.equal errors.password, "Password is incorrect.", 'password error message'
    test.end()
