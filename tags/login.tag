rockauth-login

  //- JS
  
  script
    :coffee-script
      @name = @opts.name or "rockauth:login"
      
      rocket.on "#{@name}:submit", (data) =>
        rockauth.authenticate data
        .then  (json) => rocket.trigger "#{@name}:pass", json
        .catch (json) => rocket.trigger "#{@name}:fail", json
    
      rocket.on "#{@name}:fail", (errors) =>
        rocket.trigger "#{@name}:errors", errors

  //- HTML

  rocket-login(name="{name}")
