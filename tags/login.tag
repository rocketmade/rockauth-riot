rockauth-login

  //- JS

  script
    :coffee-script
      @name = @opts.name or "rockauth:login"
      @show_forgot = @opts.show_forgot == "" or @opts.show_forgot or false

      rocketmade.on "#{@name}:submit", (data) =>
        rockauth.authenticate_with_password data
          .then (response) => rockauth.trigger "#{@name}:pass", response
          .catch (response) => rockauth.trigger "#{@name}:fail", response

      rockauth.on "#{@name}:fail", (response) =>
        console.log response.flash()
        rocketmade.trigger "#{@name}:errors", response.validation_errors()

      rocketmade.on "forgot-password:clicked", =>
        rockauth.trigger "#{@name}:forgot-password"

  //- HTML

  rocketmade-login(name="{name}", show_forgot="{ show_forgot }")
