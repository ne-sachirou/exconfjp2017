module Pressure
  class Timeout
    def self.sleep(seconds : Int32) :: Channel(Nil)
      self.sleep seconds.to_f64
    end

    def self.sleep(seconds : Float64) :: Channel(Nil)
      ch = Channel(Nil).new
      spawn do
        Fiber.sleep seconds
        ch.send nil
      end
      ch
    end

    def initialize(@timelimit : Int32)
      @waitings = [] of Channel(Nil)
    end

    def register(ch : Channel(Nil))
      @waitings << ch
      self
    end

    def start
      spawn do
        Fiber.sleep @timelimit
        @waitings.each &.send nil
      end
      self
    end
  end
end
