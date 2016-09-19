defmodule Doodit.EventManager do
  use GenServer
  require Logger

  
  @dispatcher :event_dispatcher
  @name __MODULE__

  def start_link(name) do
    GenServer.start_link(@name, [], [name: @name])
  end

  def init(_) do
    GenEvent.start_link(name: @dispatcher)
    register_handlers()
    {:ok, []}
  end

  defp register_handlers() do
    GenEvent.add_mon_handler(@dispatcher, Doodit.EventHandler, [])
  end

end