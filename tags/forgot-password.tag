rockauth-forgot-password

  //- JS

  script
    :coffee-script
      @name = @opts.name or "forgot-password"

      rocketmade.on "#{@name}:submit", (data) =>
        # display a nicer toast/flash for results
        rockauth.forgot_password data.email
          .then (response) =>
            console.log response.flash()
            rockauth.trigger "#{@name}:pass", response
          .catch (response) =>
            console.log response.flash()
            rockauth.trigger "#{@name}:fail", response

      rockauth.on "#{@name}:fail", (response) =>
        rocketmade.trigger "#{@name}:errors", response.validation_errors()

  //- HTML

  rocketmade-forgot-password(name="{ name }")