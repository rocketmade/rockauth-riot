# REQUIRE

tape      = require 'tape'
nightmare = require 'joseph/nightmare'
browser   = nightmare()

# MOCKS

api = require './api.json'

# CONFIG

tape.onFinish ->
  browser.end ->

# LOGGING

browser.on 'console', (type, args...) ->
  console.log "<console>", args...

browser.on 'page', ->
  console.log "<page>", arguments...

# CORE

@test = (label, code) ->
  tape label, (test) ->
    browser.then = (code) ->
      browser.run (error, args...) ->
        unless error
          code.call test, args...
        else
          test.fail error
          test.end()
    browser.catch = (code) ->
      browser.run (error, args...) ->
        if error then code.call test, error
    code.call browser, test

# HELPERS

@helper = (name, code) ->
  browser[name] = code.bind browser

@helper 'to', (path = '') ->
  @goto "http://localhost:3010#{path}"

# LOAD

browser.to()

# ROCKAUTH

@test "rockauth.url(value)", ->
  @evaluate ->
    rockauth.url 'http://url'
    rockauth.url()
  @then (value) ->
    @equal value, 'http://url', 'set / get value'
    @end()

@test "rockauth.client_id(value)", ->
  @evaluate ->
    rockauth.client_id 'identifier'
    rockauth.client_id()
  @then (value) ->
    @equal value, 'identifier', 'set / get value'
    @end()

@test "rockauth.client_secret(value)", ->
  @evaluate ->
    rockauth.client_secret 'secret'
    rockauth.client_secret()
  @then (value) ->
    @equal value, 'secret', 'set / get value'
    @end()

@test "rockauth.user(value)", ->
  @evaluate ->
    rockauth.user id: 1, email: "mitch@rocketmade.com"
    rockauth.user()
  @then (value) ->
    @deepLooseEqual value, id: 1, email: "mitch@rocketmade.com", 'set / get value'
    @end()

@test "rockauth.token(value)", ->
  @evaluate ->
    rockauth.token 'token'
    rockauth.token()
  @then (value) ->
    @equal value, 'token', 'set / get value'
    @end()

@test "rockauth.session(value)", ->
  @evaluate ->
    rockauth.session JSON.parse '{\"id\":5,\"token\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIxMTQzMTAsImV4cCI6MTQ4MzY1MDMxMCwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoic1dxMTdUeURLaDk5TnJSdXE0TXZQeVQvSFJoMzFsQlIifQ.ihRqi8bIF7ZIUaFbP4RG0xcWuzayFw4GLDa9mK2d9Mk\",\"token_id\":\"sWq17TyDKh99NrRuq4MvPyT/HRh31lBR\",\"expiration\":1483650310,\"client_version\":null,\"device_identifier\":null,\"device_os\":null,\"device_os_version\":null,\"device_description\":null,\"user\":{\"id\":1,\"email\":\"mitch@rocketmade.com\",\"first_name\":\"Mitch\",\"last_name\":\"Thompson\",\"provider_authentications\":[]},\"provider_authentication\":null}'
    session: rockauth.session(), user: rockauth.user(), token: rockauth.token()
  @then (object) ->
    @equal object.session.id, 5, 'sets session id'
    @equal object.session.token_id, 'sWq17TyDKh99NrRuq4MvPyT/HRh31lBR', 'sets session token id'
    @equal object.session.expiration, 1483650310, 'sets session token id'
    @equal object.user.id, 1, 'sets user id'
    @equal object.user.email, 'mitch@rocketmade.com', 'sets user email'
    @equal object.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIxMTQzMTAsImV4cCI6MTQ4MzY1MDMxMCwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoic1dxMTdUeURLaDk5TnJSdXE0TXZQeVQvSFJoMzFsQlIifQ.ihRqi8bIF7ZIUaFbP4RG0xcWuzayFw4GLDa9mK2d9Mk", "sets token"
    @end()

@test "rockauth.authenticate_with_password(opts) [pass]", ->
  @to()
  @evaluate (callback) ->
    rockauth.authenticate_with_password
      email: "mitch@rocketmade.com"
      password: "password"
    .then (data) ->
      callback null, data
  @then (json) ->
    @deepLooseEqual json, api.authentications.create.pass, 'json response'
    @end()

@test "rockauth.authenticate_with_password(opts) [fail]", ->
  @evaluate (callback) ->
    rockauth.authenticate_with_password
      email: "mitch@rocketmade.com"
      password: "bad"
    .catch (error) ->
      callback error
  @catch (error) ->
    @deepLooseEqual error, api.authentications.create.fail, 'json response'
    @end()
