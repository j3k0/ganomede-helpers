ping = (req, res, next) ->
  res.contentType = 'text'
  res.send("pong/#{req.params.token}")
  next()

module.exports = () ->
  return (prefix, server) ->
    server.get "/#{prefix}/ping/:token", ping
    server.head "/#{prefix}/ping/:token", ping

# vim: ts=2:sw=2:et:
