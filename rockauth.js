(function(){var t=[].slice;this.rockauth=function(){function e(){}return riot.observable(e),e.data=rocketmade.data,e.url=function(t){return t&&(this.url.value=t.replace(/\/$/,"")),this.url.value},e.client_id=function(t){return t&&(this.client_id.value=t),this.client_id.value},e.client_secret=function(t){return t&&(this.client_secret.value=t),this.client_secret.value},e.authentication=function(t){return t&&(this.data.set("rockauth:authentication",t),e.token(t.token)),this.data.get("rockauth:authentication")},e.user=function(t){return t&&this.data.set("rockauth:user",t),this.data.get("rockauth:user")},e.token=function(t){return t&&this.data.set("rockauth:token",t),this.data.get("rockauth:token")},e.config=function(t){return e.url(t.url),e.client_id(t.client_id),e.client_secret(t.client_secret),t},e.is_authenticated=function(){return null!==this.token()&&void 0!==this.token()},e.logout=function(){return this.authenticated_request("DELETE","/authentications").then(function(t){return console.log("DELETE /authentications endpoint returned success")})["catch"](function(t){return console.log("DELETE /authentications endpoint returned failure")}),this.data.set("rockauth:token",null)},e.authenticated_request=function(t,e,r){return rocketmade.http.request(t,""+this.url()+e,r,{headers:{Authorization:"bearer "+this.token()}})},e.forgot_password=function(t){return new rocketmade.promise(function(e){return function(r,n){return rocketmade.http.post(e.url()+"/passwords/forgot",{user:{username:t}}).then(function(t){return r(t)})["catch"](function(t){return n(t)})}}(this))},e.authenticate_with_password=function(t){return null==t&&(t={}),new rocketmade.promise(function(r){return function(n,o){return rocketmade.http.post(r.url()+"/authentications",{authentication:{auth_type:"password",client_id:r.client_id(),client_secret:r.client_secret(),username:t.username,password:t.password}}).then(function(t){var r;return e.authentication(t.json().authentications[0]),r=e.authentication().resourceOwnerCollection,e.user(t.json()[r][0]),n(t)})["catch"](function(t){return o(t)})}}(this))},e.reset_password=function(t){return null==t&&(t={}),new rocketmade.promise(function(e){return function(r,n){return rocketmade.http.post(e.url()+"/passwords/reset",{user:{password_reset_token:t.reset_token,password:t.new_password}}).then(function(t){return r(t)})["catch"](function(t){return n(t)})}}(this))},e.sideload=new(function(){function e(){}return e.prototype.load=function(e){var r,n;for(r in e)n=e[r],this.set.apply(this,[r].concat(t.call(n)));return this},e.prototype.set=function(){var e,r,n,o,a,i;for(r=arguments[0],a=2<=arguments.length?t.call(arguments,1):[],i=[],e=0,n=a.length;n>e;e++)o=a[e],i.push((null!=this[r]?this[r]:this[r]={})[o.id]=o);return i},e}()),e}()}).call(this),riot.tag2("rockauth-forgot-password",'<rocketmade-forgot-password name="{name}"></rocketmade-forgot-password>',"","",function(t){(function(){this.name=this.opts.name||"forgot-password",rocketmade.on(this.name+":submit",function(t){return function(e){return rockauth.forgot_password(e.email).then(function(e){return console.log(e.flash()),rockauth.trigger(t.name+":pass",e)})["catch"](function(e){return console.log(e.flash()),rockauth.trigger(t.name+":fail",e)})}}(this)),rockauth.on(this.name+":fail",function(t){return function(e){return rocketmade.trigger(t.name+":errors",e.validation_errors())}}(this))}).call(this)},"{ }"),riot.tag2("rockauth-login",'<rocketmade-login name="{name}" show_forgot="{show_forgot}"></rocketmade-login>',"","",function(t){(function(){this.name=this.opts.name||"rockauth:login",this.show_forgot=""===this.opts.show_forgot||this.opts.show_forgot||!1,rocketmade.on(this.name+":submit",function(t){return function(e){return rockauth.authenticate_with_password(e).then(function(e){return rockauth.trigger(t.name+":pass",e)})["catch"](function(e){return rockauth.trigger(t.name+":fail",e)})}}(this)),rockauth.on(this.name+":fail",function(t){return function(e){return console.log(e.flash()),rocketmade.trigger(t.name+":errors",e.validation_errors())}}(this)),rocketmade.on("forgot-password:clicked",function(t){return function(){return rockauth.trigger(t.name+":forgot-password")}}(this))}).call(this)},"{ }"),riot.tag2("rockauth-reset-password",'<rocketmade-center> <rocketmade-form name="{parent.name}"> <rocketmade-input name="password" type="password" placeholder="Password" require></rocketmade-input> <rocketmade-input name="confirm_password" type="password" placeholder="Confirm Password" require></rocketmade-input> <rocketmade-submit label="Change Password"></rocketmade-submit> </rocketmade-form> </rocketmade-center>','rockauth-reset-password rocketmade-form,[riot-tag="rockauth-reset-password"] rocketmade-form { display: block; margin: auto; padding: 3em; max-width: 30rem; text-align: left; }',"",function(t){(function(){this.name=this.opts.name||"reset-password",rocketmade.on(this.name+":submit",function(t){return function(e){return e.password!==e.confirm_password?void rocketmade.trigger(t.name+":errors",{confirm_password:"Passwords must match."}):rockauth.reset_password({reset_token:riot.route.query().token,new_password:e.password}).then(function(e){return console.log(e.flash()),rockauth.trigger(t.name+":success",e)})["catch"](function(e){return console.log(e.flash()),rockauth.trigger(t.name+":failure",e),rocketmade.trigger(t.name+":errors",e.validation_errors())})}}(this))}).call(this)},"{ }"),riot.tag2("rockauth-test","<rocketmade-app> <rockauth-login></rockauth-login> </rocketmade-app>","","",function(t){(function(){rockauth.url("http://localhost:3010/api"),rockauth.client_id("jkmCq3jukIA16uQyAUVWkA"),rockauth.client_secret("rKrbQSqUWgWyMRXN2PJQeHDP0E3KzRJRAasKSoI2Yvw")}).call(this)});