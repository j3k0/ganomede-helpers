superagent = require 'superagent'

class Notification
  constructor: (options={}) ->
    for key in Notification.REQUIRED_KEYS
      unless options.hasOwnProperty(key)
        throw new Error "Required key missing: `#{key}`"

      @[key] = options[key]

    for key in Notification.OPTIONAL_KEYS
      keyAllowed = options.hasOwnProperty(key) &&
        (-1 == Notification.SERVERSIDE_KEYS.indexOf(key))

      if keyAllowed
        @[key] = options[key]

  # TODO:
  # This should probably use restify.JsonClient() or ganomede client lib,
  # but let's just keep things simple for now.
  send: (uri, callback) ->
    unless @hasOwnProperty('secret')
      @secret = process.env.API_SECRET

    superagent
      .post(uri)
      .send(@)
      .end (err, res) =>
        if (err)
          # TODO:
          # Should use bunyan instead of console.
          console.error "Notification.send() failed:",
            err: err
            uri: uri
            notification: @
            response: if res then res.body else undefined

        callback?(err, res?.body)

  @REQUIRED_KEYS: ['from', 'to', 'type']
  @OPTIONAL_KEYS: ['data', 'secret']
  @SERVERSIDE_KEYS: ['id', 'timestamp'] # These are filled in
                                        # by notification service

module.exports = Notification
