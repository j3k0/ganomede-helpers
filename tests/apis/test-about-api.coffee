expect = require 'expect.js'
supertest = require 'supertest'
restify = require 'restify'
aboutApi = require '../../src/apis/about'
restifyAddons = require '../../src/restify'

CUSTOM_PREFIX = 'custom-prefix'
CUSTOM_ABOUT = {custom: true}

describe 'About API', () ->
  server = restifyAddons.createServer()
  api = aboutApi()
  go = supertest.bind(supertest, server)

  before (done) ->
    api(CUSTOM_PREFIX, server)
    server.listen(1337, done)

  after (done) ->
    server.close(done)

  it 'supports custom about field', () ->
    customAboutApi = aboutApi({about: CUSTOM_ABOUT})
    expect(customAboutApi.about).to.eql(CUSTOM_ABOUT)

  describe 'GET-ing about info', () ->
    it 'GET /about', (done) ->
      go()
        .get '/about'
        .expect 200, api.about, done

    it 'GET #{prefix}/about', (done) ->
      go()
        .get "/#{CUSTOM_PREFIX}/about"
        .expect 200, api.about, done
