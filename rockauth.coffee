# ROCKAUTH

class @rockauth

  riot.observable @

  @url: (value) ->
    @url.value = value.replace(/\/$/, '') if value
    @url.value

  @client_id: (value) ->
    @client_id.value = value if value
    @client_id.value

  @client_secret: (value) ->
    @client_secret.value = value if value
    @client_secret.value

  @token: (value) ->
    @token.value = value if value
    @token.value

  @user: (value) ->
    @user.value = value if value
    @user.value

  @session: (value) ->
    if value
      @user value.user
      @token value.token
      @session.value = value
    @session.value

  @authenticate_with_password: (opts = {}) ->
    new Promise (resolve, reject) =>
      rocketmade.http.post "#{@url()}/authentications.json",
        authentication:
          auth_type: 'password'
          client_id: @client_id()
          client_secret: @client_secret()
          username: opts.email
          password: opts.password
      .then (json) ->
        resolve json.authentication
      .catch (json) ->
        reject email: "Invalid credentials."
