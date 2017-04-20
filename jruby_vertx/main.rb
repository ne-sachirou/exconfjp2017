$vertx.create_http_server.request_handler do |req|
  req.response
     .put_header('content-type', 'text/plain')
     .end('pong')
end.listen(3000)
