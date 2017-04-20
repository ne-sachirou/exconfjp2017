// Generated by CoffeeScript 1.12.5
(function() {
  var http, server;

  http = require('http');

  server = http.createServer(function(req, res) {
    req.on('data', function(_chunk) {});
    return req.on('end', function() {
      res.writeHead(200, {
        'content-type': 'text/plain',
        'content-length': 4
      });
      return res.end('pong');
    });
  });

  server.on('clientError', function(err, socket) {
    console.error(err);
    return socket.end('HTTP/1.1 400 Bad Request\r\n\r\n');
  });

  server.listen(3000);

}).call(this);
