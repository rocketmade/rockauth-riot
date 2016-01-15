rockauth-login

  //- JS

  script
    :coffee-script
      @name = @opts.name or "rockauth:login"
      @show_forgot = @opts.show_forgot == "" or @opts.show_forgot or false

      rocketmade.on "#{@name}:submit", (data) =>
        rockauth.authenticate_with_password data
          .then (json) => rockauth.trigger "#{@name}:pass", json
          .catch (json) => rockauth.trigger "#{@name}:fail", json

      rockauth.on "#{@name}:fail", (errors) =>
        rocketmade.trigger "#{@name}:errors", errors

      rocketmade.on "forgot-password:clicked", =>
        rockauth.trigger "#{@name}:forgot-password"

  //- HTML

  rocketmade-login(name="{name}", show_forgot="{ show_forgot }")
