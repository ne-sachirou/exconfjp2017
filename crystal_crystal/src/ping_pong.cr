require "http/server"
require "./ping_pong/*"

module PingPong
  class App
    def initialize(_argv)
      server = HTTP::Server.new(3000) do |context|
        context.response.content_type = "text/plain"
        context.response.print "pong"
      end
      server.listen
    end
  end
end
