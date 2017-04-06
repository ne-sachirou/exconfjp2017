require "http/client"

module Pressure
  class Gravity
    @w_lines : Int64
    @r_lines : Int64
    @e_lines : Int64
    @res_time : Float64

    def initialize
      @w_lines = 0.to_i64
      @r_lines = 0.to_i64
      @e_lines = 0.to_i64
      @res_time = 0.to_f64
    end

    def pressure(timelimit : Int32, concurrency : Int32)
      connections = concurrency.times.map { connect }.to_a
      ch = Channel(Nil).new
      pressure? = true
      show_stats
      spawn do
        sleep timelimit
        ch.send nil
      end
      spawn do
        loop do
          break unless pressure?
          until connections.empty?
            break unless pressure?
            client = connections.pop
            spawn do
              client = ping client
              connections.push client
            end
          end
          sleep 0.001
        end
      end
      ch.receive
      pressure? = false
      sleep 0.2
    end

    private def show_stats
      spawn do
        loop do
          puts "r:#{@r_lines}\tw:#{@w_lines}\te:#{@e_lines}\tt:#{(@res_time * 100).to_i / 100.0}ms"
          sleep 0.1
          print "\033[1A\033[1G\033[0K"
        end
      end
    end

    private def connect
      HTTP::Client.new("localhost", 3000).tap do |c|
        c.connect_timeout = 1.second
        c.dns_timeout = 1.second
        c.read_timeout = 1.second
      end
    end

    private def ping(client, retrying? = false)
      @w_lines += 1
      t1 = Time.now
      begin
        res = client.post "/", body: "ping"
        t2 = Time.now
        if res.success? && res.body == "pong"
          @r_lines += 1
          @res_time = (@res_time * (@r_lines - 1) + (t2 - t1).seconds * 1000 + (t2 - t1).milliseconds) / @r_lines
        else
          @e_lines += 1
          Logger.new.error res
          client.close rescue nil
          client = connect
        end
      rescue err
        client.close rescue nil
        sleep 0.001
        client = connect
        unless retrying?
          @w_lines -= 1
          client = ping client, true
        else
          @e_lines += 1
          Logger.new.error err
        end
      end
      client
    end
  end
end
