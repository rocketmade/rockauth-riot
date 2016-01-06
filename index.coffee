express = require 'express'
app     = express()
app.use express.static 'dest'
app.listen 3010
