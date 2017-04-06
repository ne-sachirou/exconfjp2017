defmodule HedwigDemo.Responders.Ping do
  @moduledoc """
  ping-pong
  """
  use Hedwig.Responder

  hear ~r/ping/i, msg do
    reply msg, "pong"
  end
end
