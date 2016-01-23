'use strict';

import stampit from 'stampit'
import httpClient from '@rocketmade/rock-http-client'
import cookies from 'cookies-js'

/**
 * @param {String} url
 * @param {String} clientId
 * @param {String} clientSecret
 * */
export default stampit()
.init(function(){
    let rootUrl = (this.url || this.rootUrl)
    let clientId = this.clientId
    let clientSecret = this.clientSecret
    let storage = localStore.create({ namespace: 'rockauth:'})

    const buildUrl = (path) => {
        return `${rootUrl}${path}`
    }

    this.httpClient = httpClient({ fetch })

    this.authentication = (value) => {
        if(value) {
            storage.set('authentication',value)
            this.token(value.token)
        }
        return storage.get('authentication')
    }
    this.user = (value) => {
        if(value) {
            storage.set('user', value)
        }
        return storage.get('user')
    }
    this.token = (value) => {
        if(value) {
            storage.set('token',value)
        }
        return storage.get('token')
    }
    this.isAuthenticated = () => {
        return !!this.token()
    }
    this.secureResource = (self) => {
        let headers = {
            Authorization: `bearer ${this.token()}`
        }
        return this.httpClient({ self }, { headers })
    }

    this.logout = () => {
        return this.secureResource(buildUrl('/authentications'))
        .delete()
        .then((res) => {
            this.storage.set('token',null)
            return res
        })

    }
    this.forgotPassword = (username) => {
        return this.secureResource(buildUrl('/authentications'))
        .post({data:{ username }})
    }
    this.authenticateWithPassword = ({username, password}) => {
        let data = {
            username
            , password
            , auth_type: 'password'
            , client_id: clientId
            , client_secret: clientSecret
        }

        return this.secureResource(buildUrl('/authentications'))
        .post({data})
        .then({resource} => {
            throw new Error('not implemented')
            //this.authentication(resource.authentications[0])
            //this.user()
        })
    }
})


