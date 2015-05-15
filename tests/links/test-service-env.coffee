expect = require 'expect.js'
helpers = require '../../index'
ServiceEnv = require '../../src/links/service-env'

process.env.XXX_PORT_9999_TCP_ADDR = '1.2.3.4'
process.env.XXX_PORT_9999_TCP_PORT = '8888'

describe 'links.ServiceEnv', ->
  it 'is accessible through helpers.links.ServiceEnv', ->
    expect(helpers.links.ServiceEnv).to.be.ok()
  describe 'exists()', ->
    it 'retrieves environment variables', ->
      expect(helpers.links.ServiceEnv.exists('XXX', 9999)).to.be.ok()
      expect(helpers.links.ServiceEnv.exists('XXX', 8888)).not.to.be.ok()
  describe 'host()', ->
    it 'reads data from TCP_ADDR env', ->
      expect(helpers.links.ServiceEnv.host('XXX', 9999)).to.equal('1.2.3.4')
    it 'defaults to localhost', ->
      expect(helpers.links.ServiceEnv.host('XXX', 8888)).to.equal('127.0.0.1')
  describe 'port()', ->
    it 'retrieves environment variables', ->
      expect(helpers.links.ServiceEnv.port('XXX', 9999)).to.equal(8888)
      expect(helpers.links.ServiceEnv.port('XXX', 9999)).not.to.equal('8888')
    it 'defaults to the provided port', ->
      expect(helpers.links.ServiceEnv.port('XXX', 8888)).to.equal(8888)
  describe 'config()', ->
    it 'provides a object with exists, url, host and port', ->
      process.env.XXX_PORT_9999_TCP_ADDR = '1.2.3.4'
      process.env.XXX_PORT_9999_TCP_PORT = '8888'
      cfgOK = helpers.links.ServiceEnv.config('XXX', 9999)
      cfgKO = helpers.links.ServiceEnv.config('XXX', 8888)
      expect(cfgOK.exists).to.be.ok()
      expect(cfgKO.exists).not.to.be.ok()
      expect(cfgOK.host).to.equal('1.2.3.4')
      expect(cfgOK.port).to.equal(8888)
      expect(cfgOK.port).not.to.equal('8888')
