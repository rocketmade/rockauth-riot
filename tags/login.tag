rockauth-login

  //- JS
  
  script
    :coffee-script
      @name = @opts.name or "rockauth:login"
      
      rocketmade.on "#{@name}:submit", (data) =>
        rockauth.authenticate_with_password data
          .then (json) => rockauth.trigger "#{@name}:pass", json
          .catch (json) => rockauth.trigger "#{@name}:fail", json
    
      rockauth.on "#{@name}:pass", (json) ->
        rockauth.session json
    
      rockauth.on "#{@name}:fail", (errors) =>
        rocketmade.trigger "#{@name}:errors", errors

  //- HTML

  rocketmade-login(name="{name}")
