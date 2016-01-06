rockauth-test
  
  //- JS
  
  script
    :coffee-script
      rockauth.url 'http://localhost:3011/api'
      rockauth.id 'jkmCq3jukIA16uQyAUVWkA'
      rockauth.secret 'rKrbQSqUWgWyMRXN2PJQeHDP0E3KzRJRAasKSoI2Yvw'
      
      rockauth.on "rockauth:login:pass", (json) ->
        console.log "^login^", json
  
  //- HTML

  rocketmade-app
    rockauth-login
