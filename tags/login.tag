rockauth-login

  //- JS
  
  script
    :coffee-script
      @name = @opts.name or "rockauth:login"
      
      rocketmade.on "#{@name}:submit", (data) =>
        rockauth.authenticate data
        .then  (json) => rocketmade.trigger "#{@name}:pass", json
        .catch (json) => rocketmade.trigger "#{@name}:fail", json
    
      rocketmade.on "#{@name}:fail", (errors) =>
        rocketmade.trigger "#{@name}:errors", errors

  //- HTML

  rocketmade-login(name="{name}")
