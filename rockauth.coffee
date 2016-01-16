# ROCKAUTH

class @rockauth

  riot.observable @

  @data: rocketmade.data

  @url: (value) ->
    if value
      @url.value = value.replace /\/$/, ''
    @url.value

  @client_id: (value) ->
    if value
      @client_id.value = value
    @client_id.value

  @client_secret: (value) ->
    if value
      @client_secret.value = value
    @client_secret.value

  @authentication: (json) ->
    @session json.authentications[0]
    @user json.users[0]

  @session: (json) ->
    if json
      @token json.token
      @data.set 'rockauth:session', json
    @data.get 'rockauth:session'

  @user: (value) ->
    if value
      @data.set 'rockauth:user', value
    @data.get 'rockauth:user'

  @token: (value) ->
    if value
      @data.set 'rockauth:token', value
    @data.get 'rockauth:token'

  @config: (json) =>
    @url json.api.url
    @client_id json.api.client_id
    @client_secret json.api.client_secret
    json

  @is_authenticated: ->
    # TODO: check to see if token is expired
    @token() != null and @token() != undefined

  @logout: ->
    # call the DELETE authentications endpoint on the api
    @authenticated_request "DELETE", "/authentications"
    .then (response) ->
      console.log "DELETE /authentications endpoint returned success"
    .catch (response) ->
      console.log "DELETE /authentications endpoint returned failure"

    @data.set 'rockauth:token', null

  @authenticated_request: (method, endpoint, data) ->
    rocketmade.http.request method, "#{@url()}#{endpoint}", data,
      headers:
        Authorization: "bearer #{@token()}"

  @forgot_password: (username) ->
    # TODO: find a better place/way to parse and show flash messages
    new rocketmade.promise (pass, fail) =>
      rocketmade.http.post "#{@url()}/passwords/forgot",
        user:
          username: username
      .then (response) ->
        pass response
      .catch (response) ->
        fail response

  @authenticate_with_password: (opts = {}) ->
    new rocketmade.promise (pass, fail) =>
      rocketmade.http.post "#{@url()}/authentications",
        authentication:
          auth_type: 'password'
          client_id: @client_id()
          client_secret: @client_secret()
          username: opts.username
          password: opts.password
      .then (response) ->
        rockauth.authentication response.json()
        pass response
      .catch (response) ->
        fail response

  @reset_password: (opts = {}) ->
    new rocketmade.promise (pass, fail) =>
      rocketmade.http.post "#{@url()}/passwords/reset",
        user:
          password_reset_token: opts.reset_token
          password: opts.new_password
      .then (response) ->
        pass response
      .catch (response) ->
        fail response

  @sideload: new class
    constructor: ->
    load: (json) ->
      for key, value of json
        @set key, value...
      @
    set: (key, objects...) ->
      for object in objects
        (@[key] ?= {})[object.id] = object
