vertx.createHttpServer().requestHandler({ req ->
  req.response()
    .putHeader("content-type", "text/plain")
    .end("pong")
}).listen(3000)