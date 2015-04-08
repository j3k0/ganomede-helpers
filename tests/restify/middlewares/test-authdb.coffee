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

# vim: ts=2:sw=2:et:
