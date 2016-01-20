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

  @authentication: (value) ->
    if value
      @data.set 'rockauth:authentication', value
      rockauth.token value.token
    @data.get 'rockauth:authentication'

  @user: (value) ->
    if value
      @data.set 'rockauth:user', value
    @data.get 'rockauth:user'

  @token: (value) ->
    if value
      @data.set 'rockauth:token', value
    @data.get 'rockauth:token'

  @config: (json) =>
    @url json.url
    @client_id json.client_id
    @client_secret json.client_secret
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
        # get and store the authentication
        rockauth.authentication response.json().authentications[0]

        # get the name/key of the users model to retreive the user
        users_key = rockauth.authentication().resourceOwnerCollection

        # store the user
        rockauth.user response.json()[users_key][0]

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
