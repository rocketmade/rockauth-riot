# REQUIRE

tape      = require 'tape'
nightmare = require 'joseph/nightmare'
browser   = nightmare()

# MOCKS

api    = require './api.json'
config = require './config.json'

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

@test 'rockauth.authentication(json)', ->
  @evaluate (json) ->
    rockauth.authentication json
    session: rockauth.session(), user: rockauth.user(), token: rockauth.token()
  , api.authentications.create.pass
  @then (value) ->
    @equal value.session.id, 1, 'sets session id'
    @equal value.session.token_id, 'KUXCWYC3n5BdzgOVHwQnKMz7rI23QIbP', 'sets session token id'
    @equal value.user.id, 1, 'sets user id'
    @equal value.user.email, 'mitch@rocketmade.com', 'sets user email'
    @equal value.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIyNDAyMTIsImV4cCI6MTQ4Mzc3NjIxMiwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoiS1VYQ1dZQzNuNUJkemdPVkh3UW5LTXo3ckkyM1FJYlAifQ.rlq9gDcnz3ixmo3yYx05zAaIg_pR_ifFn-yvTg-NnnI", "sets token"
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

@test "rockauth.config(json)", ->
  @refresh()
  @evaluate (json) ->
    rockauth.config json
    url: rockauth.url(), client_id: rockauth.client_id(), client_secret: rockauth.client_secret()
  , config
  @then (value) ->
    @deepLooseEqual value,
      url: 'http://api',
      client_id: 'client_id'
      client_secret: 'client_secret',
      'sets correct values'
    @end()

# ROCKAUTH.AUTHENTICATE_WITH_PASSWORD

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

# ROCKAUTH.SIDELOAD

@test "rockauth.sideload.load(basic)", ->
  @evaluate ->
    rockauth.sideload.load users: [{id: 1, email: "user@email.com"}]
  @then (value) ->
    @deepLooseEqual value, users: {1: {id: 1, email: "user@email.com"}}
    @end()

@test "rockauth.sideload.load(json)", ->
  @evaluate (json) ->
    rockauth.sideload.load json
  , api.authentications.create.pass
  @then (value) ->
    @deepLooseEqual value,
      authentications:
        1:
          id: 1,
          token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJpYXQiOjE0NTIyNDAyMTIsImV4cCI6MTQ4Mzc3NjIxMiwiYXVkIjoiamttQ3EzanVrSUExNnVReUFVVldrQSIsInN1YiI6MSwianRpIjoiS1VYQ1dZQzNuNUJkemdPVkh3UW5LTXo3ckkyM1FJYlAifQ.rlq9gDcnz3ixmo3yYx05zAaIg_pR_ifFn-yvTg-NnnI',
          token_id: 'KUXCWYC3n5BdzgOVHwQnKMz7rI23QIbP',
          expiration: 1483776212,
          client_version: null,
          device_identifier: null,
          device_os: null,
          device_os_version: null,
          device_description: null,
          user_id: 1,
          provider_authentication_id: null
      users:
        1:
          id: 1,
          email: 'mitch@rocketmade.com',
          first_name: 'Mitch',
          last_name: 'Thompson'
    @end()
