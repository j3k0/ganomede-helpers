restify = require 'restify'

module.exports = (options={}) ->
  server = restify.createServer()

  server.use restify.queryParser()
  server.use restify.bodyParser()
  server.use restify.gzipResponse()

  return server
