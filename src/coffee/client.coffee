mqtt = require 'mqtt'

class Client
  constructor:(host, port,  username, password) ->
    @client = @createClient host, port,  username, password

  subscribeTo : (topic) ->
    @client.subscribe topic

  publishTo : (topic, payload) ->
    @client.publish(topic, JSON.stringify payload)

  createClient : (host, port, username, password) ->
    client = mqtt.connect {keepalive: 3000, port: port, hostname: host+"/sirmat", protocol: 'ws', username: username, password: password}

    client.on 'connect', () ->
      console.log 'client connected'

    client.on 'error', (e) ->
      console.log "Error #{e.toString()}"



module.exports = Client