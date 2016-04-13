restify = require 'restify'

SECRET_SEPARATOR = '.'

# Populates req.params.user
# with value returned from authDb.getAccount()
# or possibly faked account if options.secret is provided.
#
# Options object contains:
#  - authdbClient // object // required
#
#  - log // object // optional (defaults noop)
#    logger with .error() method.
#
#  - secret // String // optional (defaults false)
#    If specified, will try to check token against this first.
module.exports =
  create: (options) ->
    # options.authdbClient is required
    authdbClient = options.authdbClient
    if (!authdbClient)
      throw new Error "options.authdbClient is missing"

    # authorizing via secret means that authToken is:
    #   process.env.API_SECRET + SECRET_SEPARATOR + username
    secret = if options.secret then options.secret + SECRET_SEPARATOR else false
    if options.hasOwnProperty('secret')
      unless typeof options.secret == 'string' && options.secret.length > 0
        throw new Error "options.secret must be non-empty string"

    parseUsernameFromSecretToken = (token) ->
      # make sure we have both, secret and username parts
      valid = (0 == token.indexOf(secret)) && (token.length > secret.length)
      username = if valid then token.slice(secret.length) else null
      return username

    log = options.log || { error: -> }

    (req, res, next) ->
      # extract token
      authToken = req.params.authToken
      if !authToken
        return next(new restify.InvalidContentError('invalid content'))

      # check against secret
      if secret
        spoofUsername = parseUsernameFromSecretToken(authToken)
        if (spoofUsername)
          req.params.user = {
            _secret: true
            username: spoofUsername
          }
          return next()

      # check agains authdb
      authdbClient.getAccount authToken, (err, account) ->
        if err || !account
          if err
            log.error 'authdbClient.getAccount() failed',
              err: err
              token: authToken
          return next(new restify.UnauthorizedError('not authorized'))

        req.params.user = account
        next()

# vim: ts=2:sw=2:et:
