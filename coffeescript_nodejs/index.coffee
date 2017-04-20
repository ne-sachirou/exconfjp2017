http = require 'http'

server = http.createServer (req, res) ->
  req.on 'data', (_chunk) ->
  req.on 'end', ->
    res.writeHead 200,
      'content-type': 'text/plain',
      'content-length': 4
    res.end 'pong'
server.on 'clientError', (err, socket) ->
  console.error err
  socket.end 'HTTP/1.1 400 Bad Request\r\n\r\n'
server.listen 3000
