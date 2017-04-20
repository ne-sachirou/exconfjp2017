defmodule PingPong.Handler do
  @moduledoc false

  def init({:tcp, :http}, req, opts), do: {:ok, req, opts}

  def handle(req, state) do
    {:ok, req} = :cowboy_req.reply 200, [{"content-type", "text/plain"}], "pong", req
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state), do: :ok
end
