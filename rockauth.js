(function(){this.rockauth=function(){function t(){}return t.url=function(t){return t&&(this.url.value=t.replace(/\/$/,"")),this.url.value},t.id=function(t){return t&&(this.id.value=t),this.id.value},t.secret=function(t){return t&&(this.secret.value=t),this.secret.value},t.authenticate=function(t){return null==t&&(t={}),new Promise(function(e){return function(r,n){return rocketmade.http.post(e.url()+"/authentications.json",{authentication:{auth_type:"password",client_id:e.id(),client_secret:e.secret(),username:t.email,password:t.password}}).then(function(t){return r(t.authentication)})["catch"](function(t){var e,r,i;switch(i={},e=t.error,r=e.validation_errors,!1){case!r.resource_owner:i.email="We don't recognize this email.";break;case!r.password:i.password="Password is incorrect."}return n(i)})}}(this))},t}()}).call(this),riot.tag2("rockauth-login",'<rocketmade-login name="{name}"></rocketmade-login>',"","",function(t){(function(){this.name=this.opts.name||"rockauth:login",rocketmade.on(this.name+":submit",function(t){return function(e){return rockauth.authenticate(e).then(function(e){return rocketmade.trigger(t.name+":pass",e)})["catch"](function(e){return rocketmade.trigger(t.name+":fail",e)})}}(this)),rocketmade.on(this.name+":fail",function(t){return function(e){return rocketmade.trigger(t.name+":errors",e)}}(this))}).call(this)},"{ }"),riot.tag2("rockauth-test","<rocketmade-app> <rockauth-login></rockauth-login> </rocketmade-app>","","",function(t){(function(){rockauth.url("http://localhost:3011/api"),rockauth.id("jkmCq3jukIA16uQyAUVWkA"),rockauth.secret("rKrbQSqUWgWyMRXN2PJQeHDP0E3KzRJRAasKSoI2Yvw")}).call(this)});