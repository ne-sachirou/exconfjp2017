require "http/client"

module Pressure
  class Pinger
    class Stat
      getter :time

      def initialize(@is_success : Bool, @time : Int32)
      end

      def success? : Bool
        @is_success
      end
    end

    @connections : Array(HTTP::Client)

    def initialize(@concurrency : Int32)
      @connections = @concurrency.times.map do
        HTTP::Client.new("localhost", 3000).tap do |c|
          c.connect_timeout = 1.second
          c.dns_timeout = 1.second
          c.read_timeout = 1.second
        end
      end.to_a
      @logger = Logger.new
    end

    def close
      @connections.each &.close
      self
    end

    def pingable? : Bool
      !@connections.empty?
    end

    def ping : Channel(Stat)
      ch = Channel(Stat).new
      conn = @connections.pop
      spawn do
        stat = begin
                 ping_once conn
               rescue
                 conn.close rescue nil
                 begin
                   ping_once conn
                 rescue err
                   @logger.error err
                   Stat.new is_success: false, time: 0
                 end
               end
        ch.send stat
        @connections << conn
      end
      ch
    end

    private def ping_once(conn) : Stat
      t1 = Time.now
      res = conn.post "/", body: "ping"
      t2 = Time.now
      unless res.success? && res.body == "pong"
        @logger.error res
        conn.close rescue nil
        return Stat.new is_success: false, time: 0
      end
      Stat.new is_success: true, time: (t2 - t1).seconds * 1000 + (t2 - t1).milliseconds
    end
  end
end
