# REQUIRE

express = require 'express'
parser  = require 'body-parser'

# CONFIG

app     = express()
app.use express.static '.'
app.use parser.json()
app.use parser.urlencoded extended: true

# ROCKAUTH
# JSON MOCK

api = require './api.json'

# MOCK API

app.post '/api/authentications', (req, res) ->
  auth = req.body.authentication
  switch
    when auth.username == 'mitch@rocketmade.com' and auth.password == 'password'
      res.status(200).json api.authentications.create.pass
    else
      res.status(400).json api.authentications.create.fail

# LISTEN

app.listen 3010
