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

    def error(message : Object)
      @@logger.error message.to_s
    end
  end
end
