rockauth-forgot-password

  //- JS

  script
    :coffee-script
      @name = @opts.name or "forgot-password"

      rocketmade.on "#{@name}:submit", (data) =>
        # display a nicer toast/flash for results
        rockauth.forgot_password data.email
          .then (flash) =>
            alert flash
            rockauth.trigger "#{@name}:pass", json
          .catch (flash) =>
            alert flash
            rockauth.trigger "#{@name}:fail", json

      rockauth.on "#{@name}:fail", (errors) =>
        rocketmade.trigger "#{@name}:errors", errors

  //- HTML

  rocketmade-forgot-password(name="{ name }")