(function(){var t=[].slice;this.rockauth=function(){function n(){}return riot.observable(n),n.data=rocketmade.data,n.url=function(t){return t&&(this.url.value=t.replace(/\/$/,"")),this.url.value},n.client_id=function(t){return t&&(this.client_id.value=t),this.client_id.value},n.client_secret=function(t){return t&&(this.client_secret.value=t),this.client_secret.value},n.authentication=function(t){return this.session(t.authentications[0]),this.user(t.users[0])},n.session=function(t){return t&&(this.token(t.token),this.data.set("rockauth:session",t)),this.data.get("rockauth:session")},n.user=function(t){return t&&this.data.set("rockauth:user",t),this.data.get("rockauth:user")},n.token=function(t){return t&&this.data.set("rockauth:token",t),this.data.get("rockauth:token")},n.authenticate_with_password=function(t){return null==t&&(t={}),new rocketmade.promise(function(e){return function(r,i){return rocketmade.http.post(e.url()+"/authentications",{authentication:{auth_type:"password",client_id:e.client_id(),client_secret:e.client_secret(),username:t.email,password:t.password}}).then(function(t){return n.authentication(t),r(t)})["catch"](function(t){return i(t)})}}(this))},n.sideload=new(function(){function n(){}return n.prototype.load=function(n){var e,r;for(e in n)r=n[e],this.set.apply(this,[e].concat(t.call(r)));return this},n.prototype.set=function(){var n,e,r,i,a,o;for(e=arguments[0],a=2<=arguments.length?t.call(arguments,1):[],o=[],n=0,r=a.length;r>n;n++)i=a[n],o.push((null!=this[e]?this[e]:this[e]={})[i.id]=i);return o},n}()),n}()}).call(this),riot.tag2("rockauth-login",'<rocketmade-login name="{name}"></rocketmade-login>',"","",function(t){(function(){this.name=this.opts.name||"rockauth:login",rocketmade.on(this.name+":submit",function(t){return function(n){return rockauth.authenticate_with_password(n).then(function(n){return rockauth.trigger(t.name+":pass",n)})["catch"](function(n){return rockauth.trigger(t.name+":fail",n)})}}(this)),rockauth.on(this.name+":pass",function(t){return rockauth.session(t)}),rockauth.on(this.name+":fail",function(t){return function(n){return rocketmade.trigger(t.name+":errors",n)}}(this))}).call(this)},"{ }"),riot.tag2("rockauth-test","<rocketmade-app> <rockauth-login></rockauth-login> </rocketmade-app>","","",function(t){(function(){rockauth.url("http://localhost:3010/api"),rockauth.client_id("jkmCq3jukIA16uQyAUVWkA"),rockauth.client_secret("rKrbQSqUWgWyMRXN2PJQeHDP0E3KzRJRAasKSoI2Yvw")}).call(this)});