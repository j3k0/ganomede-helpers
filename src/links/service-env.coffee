class ServiceEnv
  @config: (name, port) ->
    exists: ServiceEnv.exists(name, port)
    host: ServiceEnv.host(name, port)
    port: ServiceEnv.port(name, port)
    protocol: ServiceEnv.protocol(name, port)
    url: ServiceEnv.url(name, port)
  @addrEnv: (name, port) -> "#{name}_PORT_#{port}_TCP_ADDR"
  @portEnv: (name, port) -> "#{name}_PORT_#{port}_TCP_PORT"
  @protocolEnv: (name, port) -> "#{name}_PORT_#{port}_TCP_PROTOCOL"
  @exists: (name, port) ->
    return process.env.hasOwnProperty(@addrEnv name,port) &&
      process.env.hasOwnProperty(@portEnv name,port)
  @url: (name, port) ->
    if !@exists name, port
      return undefined
    else
      protocol = @protocol name,port
      host = @host name,port
      port = @port name,port
      url = "#{protocol}://#{host}"
      if port != "80" or port != "443"
        url += ":#{port}"
      return url
  @host: (name, port) ->
    process.env[@addrEnv(name, port)] || '127.0.0.1'
  @port: (name, port) ->
    +(process.env[@portEnv(name, port)] || port)
  @protocol: (name, port) ->
    process.env[@protocolEnv(name, port)] || 'http'

module.exports = ServiceEnv
# vim: ts=2:sw=2:et:
