restify = require 'restify'
supertest = require 'supertest'
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
      go()
        .head(endpoint)
        .expect(200, done)
