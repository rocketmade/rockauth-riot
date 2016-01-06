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

@ui "rockauth.url(value)", ->
  @to '/'
  @evaluate ->
    rockauth.url 'http://url'
    rockauth.url()
  @test (value) ->
    @equal value, 'http://url', 'set / get value'
    @end()

@ui "rockauth.id(value)", ->
  @to '/'
  @evaluate ->
    rockauth.id 'identifier'
    rockauth.id()
  @test (value) ->
    @equal value, 'identifier', 'set / get value'
    @end()

@ui "rockauth.secret(value)", ->
  @to '/'
  @evaluate ->
    rockauth.secret 'secret'
    rockauth.secret()
  @test (value) ->
    @equal value, 'secret', 'set / get value'
    @end()

@ui "rockauth.user(value)", ->
  @to '/'
  @evaluate ->
    rockauth.user id: 1, email: "mitch@rocketmade.com"
    rockauth.user()
  @test (value) ->
    @deepLooseEqual value, id: 1, email: "mitch@rocketmade.com", 'set / get value'
    @end()

@ui "rockauth.token(value)", ->
  @to '/'
  @evaluate ->
    rockauth.token 'token'
    rockauth.token()
  @test (value) ->
    @equal value, 'token', 'set / get value'
    @end()

@ui "rockauth.session(value)", ->
  @to '/'
  @evaluate ->
    rockauth.session JSON.parse '{\"id\":5,\"token\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIxMTQzMTAsImV4cCI6MTQ4MzY1MDMxMCwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoic1dxMTdUeURLaDk5TnJSdXE0TXZQeVQvSFJoMzFsQlIifQ.ihRqi8bIF7ZIUaFbP4RG0xcWuzayFw4GLDa9mK2d9Mk\",\"token_id\":\"sWq17TyDKh99NrRuq4MvPyT/HRh31lBR\",\"expiration\":1483650310,\"client_version\":null,\"device_identifier\":null,\"device_os\":null,\"device_os_version\":null,\"device_description\":null,\"user\":{\"id\":1,\"email\":\"mitch@rocketmade.com\",\"first_name\":\"Mitch\",\"last_name\":\"Thompson\",\"provider_authentications\":[]},\"provider_authentication\":null}'
    session: rockauth.session(), user: rockauth.user(), token: rockauth.token()
  @test (object) ->
    @equal object.session.id, 5, 'sets session id'
    @equal object.session.token_id, 'sWq17TyDKh99NrRuq4MvPyT/HRh31lBR', 'sets session token id'
    @equal object.session.expiration, 1483650310, 'sets session token id'
    @equal object.user.id, 1, 'sets user id'
    @equal object.user.email, 'mitch@rocketmade.com', 'sets user email'
    @equal object.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIxMTQzMTAsImV4cCI6MTQ4MzY1MDMxMCwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoic1dxMTdUeURLaDk5TnJSdXE0TXZQeVQvSFJoMzFsQlIifQ.ihRqi8bIF7ZIUaFbP4RG0xcWuzayFw4GLDa9mK2d9Mk", "sets token"
    @end()

@ui "setup", ->
  @to()
  @test ->
    @end()

@ui "rockauth.authenticate_with_password(opts) [pass]", (test) ->
  @evaluate (callback) ->
    rockauth.authenticate_with_password
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

@ui "rockauth.authenticate_with_password(opts) [fail no email]", (test) ->
  @evaluate (callback) ->
    rockauth.authenticate_with_password
      email: "bad@rocketmade.com"
      password: "password"
    .catch (error) ->
      callback error
  .then null, (errors) ->
    test.deepLooseEqual errors, email: "Invalid credentials.", 'password error message'
    test.end()

@ui "rockauth.authenticate_with_password(opts) [fail wrong password]", (test) ->
  @evaluate (callback) ->
    rockauth.authenticate_with_password
      email: "mitch@rocketmade.com"
      password: "bad"
    .catch (error) ->
      callback error
  .then null, (errors) ->
    test.deepLooseEqual errors, email: "Invalid credentials.", 'password error message'
    test.end()
