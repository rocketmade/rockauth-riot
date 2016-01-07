# ROCKAUTH

class @rockauth

  riot.observable @

  @data: rocketmade.data

  @url: (value) ->
    if value
      @data.set 'rockauth:url', value.replace(/\/$/, '')
    @data.get 'rockauth:url'

  @id: (value) ->
    if value
      @data.set 'rockauth:id', value
    @data.get 'rockauth:id'

  @secret: (value) ->
    if value
      @data.set 'rockauth:secret', value
    @data.get 'rockauth:secret'

  @token: (value) ->
    if value
      @data.set 'rockauth:token', value
    @data.get 'rockauth:token'

  @user: (value) ->
    if value
      @data.set 'rockauth:user', value
    @data.get 'rockauth:user'

  @session: (value) ->
    if value
      @user value.user
      @token value.token
      @data.set 'rockauth:session', value
    @data.get 'rockauth:session'

  @authenticate_with_password: (opts = {}) ->
    new Promise (resolve, reject) =>
      rocketmade.http.post "#{@url()}/authentications.json",
        authentication:
          auth_type: 'password'
          client_id: @id()
          client_secret: @secret()
          username: opts.email
          password: opts.password
      .then (json) ->
        resolve json.authentication
      .catch (json) ->
        reject email: "Invalid credentials."
