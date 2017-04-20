require "logger"

module Pressure
  class Logger
    include IO
    @@logger : ::Logger = ::Logger.new File.open("pressure.log", "a")

    def read(slice : Bytes)
      slice.size
    end

    def write(slice : Bytes)
      error String.new slice
      nil
    end

    def error(message : String)
      @@logger.error message
    end

    def error(message)
      @@logger.error message.inspect
    end
  end
end
