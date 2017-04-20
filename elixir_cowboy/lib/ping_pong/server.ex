defmodule PingPong.Server do
  @moduledoc false

  def start_link do
    dispatch = :cowboy_router.compile([
      {
        :_,
        [{"/", PingPong.Handler, []}]
      }
    ])
    {:ok, _} = :cowboy.start_http :ping_pong, 1000, [port: 3000, max_connections: 2048], [env: [dispatch: dispatch]]
  end
end
