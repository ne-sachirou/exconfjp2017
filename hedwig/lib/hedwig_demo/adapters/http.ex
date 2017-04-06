defmodule HedwigDemo.Adapters.Http do
  @moduledoc """
  """
  use Hedwig.Adapter

  def init({robot, opts}) do
    GenServer.cast self(), :after_init
    {:ok, %{robot: robot, opts: opts}}
  end

  @spec message(pid, binary) :: :ok
  def message(req, msg) do
    GenServer.cast __MODULE__, {:message, req, %{text: msg}}
  end

  def handle_cast(:after_init, %{robot: robot} = state) do
    Process.register self(), __MODULE__
    :ok = Hedwig.Robot.handle_connect robot
    {:noreply, state}
  end

  def handle_cast({:message, req, %{text: text}}, %{robot: robot} = state) do
    Hedwig.Robot.handle_in robot, %Hedwig.Message{
      ref: make_ref(),
      robot: robot,
      room: :erlang.term_to_binary(req),
      text: text,
      user: %Hedwig.User{}
    }
    {:noreply, state}
  end

  def handle_cast({:send, %{room: room, text: text}}, state) do
    Kernel.send :erlang.binary_to_term(room), text
    {:noreply, state}
  end

  def handle_cast({:reply, msg}, state) do
    GenServer.cast self(), {:send, msg}
    {:noreply, state}
  end

  def handle_cast({:emote, msg}, state) do
    GenServer.cast self(), {:send, msg}
    {:noreply, state}
  end
end
