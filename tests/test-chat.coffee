http = require 'http'
expect = require 'expect.js'
Chat = (require '../index').Chat
_ = require 'lodash'

describe 'Chat', () ->
  createWithDefaults = (fields={}) ->
    return new Chat _.extend {}, fields,
      type: 'type'
      users: [ 'user1', 'user2' ]
      timestamp: Date.now()
      message: 'message'

  describe 'new Chat()', () ->
    it 'creates chat', () ->
      expected =
        type: 'type'
        users: [ 'user1', 'user2' ]
        timestamp: Date.now()
        message: 'message'

      expect(new Chat(expected)).to.eql expected

    it 'throws if required fileds are missing', () ->
      re = /Required key missing/
      ctor = (args) -> new Chat(args)

      expect(ctor).to.throwException(re)
      expect(ctor).withArgs(type:'t').to.throwException(re)

    it 'does not include unlisted keys', () ->
      n = createWithDefaults
        these: 'keys'
        are: 'neither'
        required: 'nor optional'

      expect(n).not.to.have.property('these')
      expect(n).not.to.have.property('are')
      expect(n).not.to.have.property('required')

  describe '.send() / .sendFn()', () ->
    expectedReply = {ok: true}
    server = http.createServer (req, res) ->
      res.setHeader('content-type', 'application/json')
      res.end(JSON.stringify(expectedReply))

    sendChatNoop = Chat.sendFn(true)
    process.env.CHAT_PORT_8080_TCP_ADDR = 'localhost'
    process.env.CHAT_PORT_8080_TCP_PORT = '1339'
    sendChat = Chat.sendFn()

    before (done) -> server.listen(1339, 'localhost', done)
    after (done) -> server.close(done)

    it '.send() works', (done) ->
      sendChat createWithDefaults(), (err, res) ->
        expect(err).to.be(null)
        expect(res).to.eql(expectedReply)
        done()

    it '.sendFn() returns noop() that able to call callback', (done) ->
      sendChatNoop('chat-argument', done)

