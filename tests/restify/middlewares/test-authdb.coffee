expect = require 'expect.js'
restify = require 'restify'

helpers = require '../../../index'
authdbMiddleware = require '../../../src/restify/middlewares/authdb'

describe 'restify.middlewares.authdb', () ->

  it 'is accessible through restify.middlewares.authdb', ->
    expect(helpers.restify.middlewares.authdb).to.be.ok()

  it 'requires a authdbClient', ->
    expect(authdbMiddleware.create).to.throwError()
    createWithAuth = authdbMiddleware.create.bind(null,authdbClient:true)
    expect(createWithAuth).not.to.throwError()

  it 'fails if not authToken are provided', (done) ->
    middleware = authdbMiddleware.create authdbClient:true
    middleware params:{}, null, (err) ->
      expect(err).to.be.an(restify.InvalidContentError)
      done()

  it 'fails if authToken does not exist', (done) ->
    middleware = authdbMiddleware.create
      authdbClient: getAccount: (authToken, cb) -> cb true
    middleware params: authToken: 'dummy', null, (err) ->
      expect(err).to.be.an(restify.UnauthorizedError)
      done()

  it 'stores user if authToken exists', (done) ->
    middleware = authdbMiddleware.create
      authdbClient: getAccount: (authToken, cb) -> cb null, 12345
    params = authToken: 'dummy'
    middleware params:params, null, (err) ->
      expect(!err).to.be.ok()
      expect(params.user).to.be(12345)
      done()

  describe 'authorizing with secret', (done) ->
    apiSecret = 'process.env.API_SECRET'

    middleware = authdbMiddleware.create({
      authdbClient: getAccount: (token, cb) -> cb new Error('SecretPlease')
      secret: apiSecret
    })

    it 'allows authorizing as user via secret', (done) ->
      params = {authToken: "#{apiSecret}.jdoe"}

      middleware {params}, null, (err) ->
        expect(err).to.be(undefined)
        expect(params.user).to.be.ok()
        expect(params.user.username).to.be('jdoe')
        done()


    it 'flags accounts authorized via secret', (done) ->
      params = {authToken: "#{apiSecret}.jdoe"}

      middleware {params}, null, (err) ->
        expect(err).to.be(undefined)
        expect(params.user).to.be.ok()
        expect(params.user._secret).to.be(true)
        done()

    it 'rejects secrets without username', (done) ->
      params = {authToken: "#{apiSecret}."}
      middleware {params}, null, (err) ->
        expect(err).to.be.a(restify.UnauthorizedError)
        expect(params.user).to.be(undefined)
        done()

    it 'rejects invalid secrets', (done) ->
      params = {authToken: "not-#{apiSecret}.jdoe"}
      middleware {params}, null, (err) ->
        expect(err).to.be.a(restify.UnauthorizedError)
        expect(params.user).to.be(undefined)
        done()

# vim: ts=2:sw=2:et:
