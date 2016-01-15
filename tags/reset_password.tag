rockauth-reset_password
  
  // JS
  script
    :coffee-script
      @name = @opts.name or "rockauth:reset_password"
      
      rocketmade.on "#{@name}:submit", (data) =>
        if data.password == data.confirm_password
          console.log "Passwords match!"
          
          rockauth.reset_password({
            reset_token: null,
            new_password: null
          })

  // HTML
  p { message }
  rocketmade-center
    rocketmade-form(name="{parent.name}")
      rocketmade-input(name="password", type="password", placeholder="Password", require)
      rocketmade-input(name="confirm_password", type="password", placeholder="Confirm Password", require)
      rocketmade-submit(label="Change Password")
  
  // CSS
  style(scoped)
    :stylus
      rocketmade-form
        display block
        margin auto
        padding 3em
        max-width 30rem
        text-align left