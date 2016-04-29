restify = require 'restify'
supertest = require 'supertest'
superagent = require 'superagent'
expect = require 'expect.js'
pingApi = require '../../src/apis/ping'
restifyAddons = require '../../src/restify'

describe 'Ping API', () ->
  api = pingApi()
  server = restifyAddons.createServer()
  go = supertest.bind(supertest, server)
  prefix = 'some-prefix'
  token = 'some-token'
  endpoint = "/#{prefix}/ping/#{token}"
  expectedResponse = "pong/#{token}"

  before (cb) ->
    api(prefix, server)
    server.listen(1337, cb)

  after (cb) ->
    server.close(cb)

  describe '/#{prefix}/ping', () ->
    it 'GET', (done) ->
      go()
        .get(endpoint)
        .expect(200, expectedResponse, done)

    it 'HEAD', (done) ->
      addr = server.address()
      uri = "http://localhost:#{addr.port}#{endpoint}"
      superagent
        .head(uri)
        .end (err, res) ->
          expect(err).to.be(null)
          expect(res.statusCode).to.be(200)
          done()

