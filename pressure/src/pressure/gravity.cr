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
      ch = Channel(Nil).new
      Timeout.new(timelimit).tap do |t|
        t.register ch
        t.register show_stats
        t.register ping concurrency
        t.start
      end
      ch.receive
      sleep 1.1
      self
    end

    private def show_stats
      ch = Channel(Nil).new
      spawn do
        loop do
          puts "r:#{@r_lines}\tw:#{@w_lines}\te:#{@e_lines}\tt:#{(@res_time * 1000).to_i / 1000.0}ms"
          select
          when ch.receive then break
          when Timeout.sleep(0.1).receive
          end
          print "\033[1A\033[1G\033[0K"
        end
        sleep 1
        puts "\033[1A\033[1G\033[0Kr:#{@r_lines}\tw:#{@w_lines}\te:#{@e_lines}\tt:#{(@res_time * 1000).to_i / 1000.0}ms"
      end
      ch
    end

    private def ping(concurrency)
      ch = Channel(Nil).new
      is_timeout = false
      spawn do
        ch.receive
        is_timeout = true
      end
      spawn do
        pinger = Pinger.new concurrency
        loop do
          break if is_timeout
          while pinger.pingable?
            break if is_timeout
            pinger.ping.tap do |ch_stat|
              spawn do
                stat = ch_stat.receive
                @w_lines += 1
                if stat.success?
                  @r_lines += 1
                  @res_time = (@res_time * (@r_lines - 1) + stat.time) / @r_lines
                else
                  @e_lines += 1
                end
              end
            end
          end
          sleep 0.001
        end
        sleep 1
        pinger.close
      end
      ch
    end
  end
end
