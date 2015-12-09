superagent = require 'superagent'
ServiceEnv = require './links/service-env'

class Chat
  @logError: console.error.bind(console)
  constructor: (options={}) ->
    for key in Chat.REQUIRED_KEYS
      unless options.hasOwnProperty(key)
        throw new Error "Required key missing: `#{key}`"

      @[key] = options[key]

  # TODO:
  # This should probably use restify.JsonClient() or ganomede client lib,
  # but let's just keep things simple for now.
  @send: (uri, chat, callback) ->

    superagent
      .post(uri)
      .send(chat)
      .end (err, res) ->
        if (err)
          Chat.logError "Chat.send() failed",
            err: err
            uri: uri
            chat: chat
            response: if res then res.body else undefined

        callback?(err, res?.body)

  # If process.env has variables with CHAT service address,
  # returns Chat.send() bound to that address. Otherwise throws
  # an error or returns noop depending on @noopIfNotFound argument.
  #
  # Example:
  #   sendChat = Chat.sendFn()
  #   # now you can use `sendChat(chat, callback)` in your code:
  #   sendChat(new Chat(...))
  #
  @sendFn: (noopIfNotFound) ->
    unless ServiceEnv.exists('CHAT', 8080)
      unless noopIfNotFound
        throw new Error("Chat.sendFn() failed to
          find CHAT service address in environment variables")

      # noop
      return () ->
        callback = arguments[arguments.length - 1]
        callback?(null)

    baseURL = ServiceEnv.url('CHAT', 8080)
    url = "#{baseURL}/chats/v1/auth/" +
      process.env.API_SECRET + "/system-messages"
    return (chat, callback) ->
      Chat.send(url, chat, callback)

  @REQUIRED_KEYS: ['users', 'type', 'message', 'timestamp']

module.exports = Chat

