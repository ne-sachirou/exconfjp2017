require "http/client"
require "option_parser"
require "./pressure/*"

module Pressure
  class App
    def initialize(argv : Array(String))
      bot_name = argv[0]?
      raise "Unknown bot #{bot_name}" unless bot_name && %w(botkit hedwig).includes?(bot_name)
      timelimit = 60
      concurrency = 100
      OptionParser.parse(argv) do |parser|
        parser.on("-t TIMELIMIT", "--timelimit TIMELIMIT" ,"") { |t| timelimit = t.to_i }
        parser.on("-c CONCURRENCY", "--concurrency CONCURRENCY", "") { |c| concurrency = c.to_i }
      end
      bot = start_bot bot_name
      Gravity.new.pressure timelimit: timelimit, concurrency: concurrency
      bot.kill rescue nil
    end

    private def start_bot(bot : String)
      bot = Process.new "make", %w(start),
                        chdir: File.join("..", bot),
                        output: Logger.new,
                        error: Logger.new
      print "Waiting"
      loop do
        begin
          print "."
          res = HTTP::Client.post "http://localhost:3000/", body: "ping"
          break if res.success?
        rescue
        end
        sleep 1
      end
      print "\033[1G\033[0K"
      bot
    end
  end
end
