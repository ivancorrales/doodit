defmodule Doodit.EventHandlerWatcher do
  use GenServer
  require Logger

  def start_link(event_manager, handler, args \\ []) do
    GenServer.start_link(__MODULE__,[event_manager, handler, args], name: handler)
  end

  def init({manager,args}) do
    start_handler(manager, args)
    {:ok, manager}
  end

  def start_handler(manager, args) do
    case GenEvent.add_mon_handler(Doodit.EventHandler, manager, args) do
      :ok -> {:ok, manager}
      {:error, :ignore} -> :ignore # special case to ignore handler
      {:error, reason} -> exit({:failed_to_add_handler, manager, reason})
    end
  end

  def handle_info({:DOWN, _, _, {Doodit.EventHandler, _node}, _reason}, _from) do
    {:stop, "EventManager down.", []}
  end

  def handle_info({:gen_event_EXIT, _handler, reason}, state) when reason in [:normal, :shutdown] do
    Logger.info "event down reason: #{reason}"
    {:stop, reason, state}
  end

  def handle_info({:gen_event_EXIT, _handler, reason}, state) do
    Logger.info "event down reason: #{reason}"
    start_handler(state, [])
    {:noreply, state}
  end



end