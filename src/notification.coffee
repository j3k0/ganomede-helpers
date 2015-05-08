superagent = require 'superagent'
ServiceEnv = require './links/service-env'

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
  @send: (uri, notification, callback) ->
    unless notification.hasOwnProperty('secret')
      notification.secret = process.env.API_SECRET

    superagent
      .post(uri)
      .send(notification)
      .end (err, res) ->
        if (err)
          # TODO:
          # Should use bunyan instead of console.
          console.error "Notification.send() failed:",
            err: err
            uri: uri
            notification: notification
            response: if res then res.body else undefined

        callback?(err, res?.body)

  # If process.env has variables with NOTIFICATIONS service address,
  # returns Notification.send() bound to that address. Otherwise throws
  # an error or returns noop depending on @noopIfNotFound argument.
  #
  # Example:
  #   sendNotification = Notification.sendFn()
  #   # now you can use `sendNotification(notification, callback)` in your code:
  #   sendNotification(new Notification(...))
  #
  @sendFn: (noopIfNotFound) ->
    unless ServiceEnv.exists('NOTIFICATIONS', 8080)
      unless noopIfNotFound
        throw new Error("Notification.sendFn() failed to
          find NOTIFICATIONS service address in environment variables")

      # noop
      return () ->
        callback = arguments[arguments.length - 1]
        callback?(null)

    baseURL = ServiceEnv.url('NOTIFICATIONS', 8080)
    url = "#{baseURL}/notifications/v1/messages"
    return (notification, callback) ->
      Notification.send(url, notification, callback)

  @REQUIRED_KEYS: ['from', 'to', 'type']
  @OPTIONAL_KEYS: ['data', 'secret']
  @SERVERSIDE_KEYS: ['id', 'timestamp'] # These are filled in
                                        # by notification service

module.exports = Notification
