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

  @domain: ->
    return @domain.value if @domain.value

    # TODO: this won't work for website.co.uk type domains
    parts = document.domain.split '.'
    while parts.length > 2
      parts.shift()

    @domain.value = "#{parts[0]}.#{parts[1]}"

  # TODO: encrypt these
  @set_cookie: (name, value, days_to_live = 30) ->
    return @delete_cookie(name) if value == null

    d = new Date
    d.setTime d.getTime() + days_to_live*24*60*60*1000
    expires = "expires=#{d.toUTCString()}"
    domain = "domain=.#{@domain()}"
    document.cookie = "#{name}=#{JSON.stringify(value)}; #{expires}; #{domain}; path=/"

  @get_cookie: (name) ->
    cookies = document.cookie.split ';'
    for index, cookie of cookies
      key_val = cookie.trim().split '='
      return JSON.parse(key_val[1]) if key_val[0] == name
    null

  @delete_cookie: (name) ->
    document.cookie = "#{name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; domain=.#{@domain()}";

  @authentication: (value) ->
    if value
      document.cookie = rockauth
      @set_cookie 'rockauth:authentication', value
      rockauth.token value.token
    @data.get 'rockauth:authentication'

  @user: (value) ->
    if value
      @set_cookie 'rockauth:user', value
    @get_cookie 'rockauth:user'

  @token: (value) ->
    if value
      @set_cookie 'rockauth:token', value
    @get_cookie 'rockauth:token'

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

    @delete_cookie 'rockauth:token'

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
