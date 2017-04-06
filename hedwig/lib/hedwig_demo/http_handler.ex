defmodule HedwigDemo.HttpHandler do
  @moduledoc false
  require Logger

  def start do
    dispatch = :cowboy_router.compile([
      {
        :_,
        [{"/", __MODULE__, []}]
      }
    ])
    {:ok, _} = :cowboy.start_http :hedwig_demo, 1000, [port: 3000, max_connections: 2048], [env: [dispatch: dispatch]]
  end

  def init({:tcp, :http}, req, opts), do: {:ok, req, opts}

  def handle(req, state) do
    {:ok, body, req} = :cowboy_req.body req
    HedwigDemo.Adapters.Http.message self(), body
    {:ok, req} =
      receive do
      msg -> :cowboy_req.reply 200, [{"content-type", "text/plain"}], msg, req
      after 500 ->
        :cowboy_req.reply 400, [{"content-type", "text/plain"}], "Bad Request", req
        Logger.error "HTTP 400 Bad Request"
      end
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state), do: :ok
end
