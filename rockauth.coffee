# ROCKAUTH

class @rockauth

  riot.observable @

  @url: (value) ->
    @url.value = value.replace(/\/$/, '') if value
    @url.value

  @id: (value) ->
    @id.value = value if value
    @id.value

  @secret: (value) ->
    @secret.value = value if value
    @secret.value

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
          client_id: @id()
          client_secret: @secret()
          username: opts.email
          password: opts.password
      .then (json) ->
        resolve json.authentication
      .catch (json) ->
        object = {}
        error = json.error
        errors = error.validation_errors
        switch
          when errors.resource_owner
            object.email = "We don't recognize this email."
          when errors.password
            object.password = "Password is incorrect."
        reject object
