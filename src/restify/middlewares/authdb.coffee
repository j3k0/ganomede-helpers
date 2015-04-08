restify = require 'restify'
expect = require 'expect.js'

# Populates req.params.user with value returned from authDb.getAccount()
module.exports =
  create: (options) ->

    authdbClient = options.authdbClient
    if (!authdbClient)
      throw new Error "options.authdbClient is missing"

    log = options.log || { error: -> }

    (req, res, next) ->
      authToken = req.params.authToken
      if !authToken
        return next(new restify.InvalidContentError('invalid content'))

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
