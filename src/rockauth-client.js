'use strict';

import stampit from 'stampit'
import httpClient from '@rocketmade/rock-http-client'
import cookies from 'cookies-js'

var cookieStrategy = stampit()
  .init(function(){
    let storage = cookies(window)
    let domain
    /* http://jsfiddle.net/zEwsP/4/ */
    this.get = (key) => {
      return storage.get(key)
    }
    this.set = (key, value) => {
      return storage.set(key, value)
    }
    this.expire = (key) => {
      return storage.expire(key)
    }
  })

var localStorageStrategy = stampit()
  .init(function(){
    this.get = (key) => {

    }
    this.set = (key, value) => {

    }
    this.expire = (key) => {

    }
  })

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
    let storage = (this.cookies ? cookieStrategy() : localStorageStrategy())

    const namespaced = (key) => {
      return `rockauth:${key}`
    }

    const buildUrl = (path) => {
      return `${rootUrl}${path}`
    }

    this.httpClient = httpClient({ fetch })

    this.authentication = (value) => {
      if(value) {
        storage.set(namespaced('authentication'),value)
        this.token(value.token)
      }
      return storage.get(namespaced('authentication'))
    }
    this.user = (value) => {
      if(value) {
        storage.set(namespaced('user', value))
      }
      return storage.get(namespaced('user'))
    }
    this.token = (value) => {
      if(value) {
        storage.set(namespaced('token'),value)
      }
      return storage.get(namespaced('token'))
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
          this.storage.expire(namespaced('token'))
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
        .then((resource) => {
          throw new Error('not implemented')
          //this.authentication(resource.authentications[0])
          //this.user()
        })
    }
  })
