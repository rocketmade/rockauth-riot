# ROCKAUTH

class @rockauth

  riot.observable @

  @data: rocketmade.data

  @url: (value) ->
    if value
      @data.set 'rockauth:url', value.replace(/\/$/, '')
    @data.get 'rockauth:url'

  @client_id: (value) ->
    if value
      @data.set 'rockauth:client_id', value
    @data.get 'rockauth:client_id'

  @client_secret: (value) ->
    if value
      @data.set 'rockauth:client_secret', value
    @data.get 'rockauth:client_secret'

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
    rocketmade.http.post "#{@url()}/authentications",
      authentication:
        auth_type: 'password'
        client_id: @client_id()
        client_secret: @client_secret()
        username: opts.email
        password: opts.password
