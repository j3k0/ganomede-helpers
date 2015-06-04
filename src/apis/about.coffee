# About

os = require "os"
path = require "path"

defaultAbout = () ->
  # So we don't read helpers package.json, but main package.json.
  pk = require(path.join(process.cwd(), 'package.json'))

  return {
    hostname: os.hostname()
    type: pk.name
    version: pk.version
    description: pk.description
    startDate: (new Date).toISOString()
  }

module.exports = (options={}) ->
  about = options.about || defaultAbout()

  sendAbout = (req, res, next) ->
    res.json(about)
    next()

  api = (prefix, server) ->
    server.get "/about", sendAbout
    server.get "/#{prefix}/about", sendAbout

  api.about = about
  return api
