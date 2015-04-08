expect = require 'expect.js'
helpers = require '../../index'
ServiceEnv = require '../../src/links/service-env'

describe 'links.ServiceEnv', ->
  it 'is accessible through links.ServiceEnv', ->
    expect(helpers.links.ServiceEnv).to.be.ok()
  it 'retrieves environment variables', ->
    process.env.XXX_PORT_9999_TCP_ADDR = '1.2.3.4'
    process.env.XXX_PORT_9999_TCP_PORT = '8888'
    expect(helpers.links.ServiceEnv.exists('XXX', 9999)).to.be.ok()
    expect(helpers.links.ServiceEnv.exists('XXX', 8888)).not.to.be.ok()
    expect(helpers.links.ServiceEnv.host('XXX', 9999)).to.equal('1.2.3.4')
    expect(helpers.links.ServiceEnv.port('XXX', 9999)).to.equal(8888)
    expect(helpers.links.ServiceEnv.port('XXX', 9999)).not.to.equal('8888')
