rockauth-reset-password

  // JS

  script
    :coffee-script
      @name = @opts.name or "reset-password"

      rocketmade.on "#{@name}:submit", (data) =>
        # TODO: find a way to move this validation to the form or input tags
        if data.password == data.confirm_password
          rockauth.reset_password { reset_token: riot.route.query().token, new_password: data.password }
            .then (response) =>
              console.log response.flash()
              rockauth.trigger "#{@name}:success", response
            .catch (response) =>
              # TODO: show these flashes
              console.log response.flash()
              rockauth.trigger "#{@name}:failure", response
              rocketmade.trigger "#{@name}:errors", response.validation_errors()
        else
          rocketmade.trigger "#{@name}:errors", { confirm_password: "Passwords must match." }

  // HTML

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