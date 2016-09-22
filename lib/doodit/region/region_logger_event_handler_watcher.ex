defmodule Doodit.Region.LoggerEventHandlerWatcher do
  use GenServer

  @doc """
    starts the GenServer, this should be done by a Supervisor to ensure
    restarts if it itself goes down
  """
  def start_link(event_manager, opts \\[]) do
    
    GenServer.start_link(__MODULE__, event_manager, opts)
  end

  @doc """
    inits the GenServer by starting a new handler
  """
  def init(event_manager) do
    start_handler(event_manager)
  end

  @doc """
    handles EXIT messages from the GenEvent handler and restarts it
  """
  def handle_info({:gen_event_EXIT, _handler, _reason}, event_manager) do
    {:ok, event_manager} = start_handler(event_manager)
    {:noreply, event_manager}
  end

  
  defp start_handler(event_manager) do
    case GenEvent.add_mon_handler(event_manager, Doodit.Region.LoggerEventHandler, []) do
     :ok ->
       {:ok, event_manager}
     {:error, reason}  ->
       {:stop, reason}
    end
  end
end