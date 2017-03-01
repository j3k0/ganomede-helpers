expect = require 'expect.js'
helpers = require '../../index'
ServiceEnv = helpers.links.ServiceEnv

process.env.XXX_PORT_9999_TCP_ADDR = '1.2.3.4'
process.env.XXX_PORT_9999_TCP_PORT = '8888'
process.env.XXX_PORT_9999_TCP_PROTOCOL = 'sftp'

describe 'links.ServiceEnv', ->
  it 'is accessible through helpers.links.ServiceEnv', ->
    expect(ServiceEnv).to.be.ok()
  describe 'exists()', ->
    it 'retrieves environment variables', ->
      expect(ServiceEnv.exists('XXX', 9999)).to.be.ok()
      expect(ServiceEnv.exists('XXX', 8888)).not.to.be.ok()
  describe 'host()', ->
    it 'reads data from TCP_ADDR env', ->
      expect(ServiceEnv.host('XXX', 9999)).to.equal('1.2.3.4')
    it 'defaults to localhost', ->
      expect(ServiceEnv.host('XXX', 8888)).to.equal('127.0.0.1')
  describe 'port()', ->
    it 'retrieves environment variables', ->
      expect(ServiceEnv.port('XXX', 9999)).to.equal(8888)
      expect(ServiceEnv.port('XXX', 9999)).not.to.equal('8888')
    it 'defaults to the provided port', ->
      expect(ServiceEnv.port('XXX', 8888)).to.equal(8888)
  describe 'protocol()', ->
    it 'retrieves environment variables', ->
      expect(ServiceEnv.protocol('XXX', 9999)).to.equal('sftp')
    it 'defaults to http', ->
      expect(ServiceEnv.protocol('XXX', 8888)).to.equal('http')
  describe 'config()', ->
    it 'provides a object with exists, url, host and port', ->
      process.env.XXX_PORT_9999_TCP_ADDR = '1.2.3.4'
      process.env.XXX_PORT_9999_TCP_PORT = '8888'
      cfgOK = ServiceEnv.config('XXX', 9999)
      cfgKO = ServiceEnv.config('XXX', 8888)
      expect(cfgOK.exists).to.be.ok()
      expect(cfgKO.exists).not.to.be.ok()
      expect(cfgOK.host).to.equal('1.2.3.4')
      expect(cfgOK.port).to.equal(8888)
      expect(cfgOK.port).not.to.equal('8888')
