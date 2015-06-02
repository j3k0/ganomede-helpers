restify = require 'restify'
supertest = require 'supertest'
pingApi = require '../../src/apis/ping'

describe 'Ping API', () ->
  api = pingApi()
  server = restify.createServer()
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
      go()
        .head(endpoint)
        .expect(200, done)
