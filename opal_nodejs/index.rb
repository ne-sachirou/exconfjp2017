`var http = require('http')`

server = `http`.JS.createServer do |req, res|
  req_on = req.JS[:on].JS.bind req
  req_on.call('data', -> {})
  req_on.call('end', lambda do
    res.JS.writeHead(
      200,
      'content-type' => 'text/plain',
      'content-length' => 4
    )
    res.JS.end 'pong'
  end)
end
server.JS.listen 3_000
