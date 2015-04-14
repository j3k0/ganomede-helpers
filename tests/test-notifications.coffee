http = require 'http'
expect = require 'expect.js'
Notification = require '../src/notification'

describe 'Notification', () ->
  createWithDefaults = (fields={}) ->
    values =
      from: fields.from || 'x'
      to: fields.to || 'y'
      type: fields.type || 'type'

    for own key, val of fields
      values[key] = val

    return new Notification(values)

  describe 'new Notification()', () ->
    it 'creates notification', () ->
      expected =
        from: 'from'
        to: 'to'
        type: 'type'
        data: {some: {data: 'object'}}
        secret: 'custom-secret'

      expect(new Notification(expected)).to.eql(expected)

    it 'throws if required fileds are missing', () ->
      re = /Required key missing/
      ctor = (args) -> new Notification(args)

      expect(ctor).to.throwException(re)
      expect(ctor).withArgs({from: 'x', to: 'y'}).to.throwException(re)

    it 'does not include unlisted keys', () ->
      n = createWithDefaults
        these: 'keys'
        are: 'neither'
        required: 'nor optional'

      expect(n).not.to.have.property('these')
      expect(n).not.to.have.property('are')
      expect(n).not.to.have.property('required')

    it 'does not include server-generated keys', () ->
      n = createWithDefaults
        id: 'nope'
        timestamp: 42

      expect(n).not.to.have.property('id')
      expect(n).not.to.have.property('timestamp')

  describe '#send()', () ->
    server = http.createServer (req, res) ->
      res.setHeader('content-type', 'application/json')
      res.end(JSON.stringify(expectedReply))

    expectedReply = {ok: true}

    before (done) -> server.listen(1337, 'localhost', done)
    after (done) -> server.close(done)

    it 'works', (done) ->
      createWithDefaults().send 'localhost:1337', (err, res) ->
        expect(err).to.be(null)
        expect(res).to.eql(expectedReply)
        done()
