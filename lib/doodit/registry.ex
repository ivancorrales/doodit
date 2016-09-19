defmodule Doodit.Registry do
  use GenServer
  require Logger


  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(table, event_manager, regions, opts \\ []) do
    GenServer.start_link(__MODULE__, {table, event_manager, regions}, opts)
  end

  @doc """
  Looks up the region pid for `name` stored in `table`.
  Returns `{:ok, pid}` if the region exists, `:error` otherwise.
  """
  def lookup(table, name) do
    case :ets.lookup(table, name) do
      [{^name, region}] -> {:ok, region}
      [] -> :error
    end
  end

  @doc """
  Ensures there is a region associated to the given `name` in `server`.
  """
  def create(server, name) do
    Logger.info "registry creation"
    GenServer.call(server, {:create, name})
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    Logger.info "registry stop"
    GenServer.call(server, :stop)
  end


  ## Server Callbacks

  def init({table, events, regions}) do
    refs = :ets.foldl(fn {name, pid}, acc ->
      Map.put(acc, Process.monitor(pid), name)
    end, Map.new, table)

    {:ok, %{names: table, refs: refs, events: events, regions: regions}}
  end

  def handle_call({:stop}, _from, state) do
    IO.puts "handle_call_stop"
    {:stop, :normal, :ok, state}
  end

  def handle_call({:create, name}, _from, state) do
    case lookup(state.names, name) do
      {:ok, pid} ->
        {:reply, pid, state} ## Reply with pid
      :error ->
        {:ok, pid} = Doodit.Region.Supervisor.start_region(state.regions)
        ref = Process.monitor(pid)
        refs = Map.put(state.refs, ref, name)
        :ets.insert(state.names, {name, pid})
        GenEvent.sync_notify(state.events, {:create, name, pid})
        {:reply, pid, %{state | refs: refs}} ## Reply with pid
    end
  end

  def handle_info({:DOWN, ref, :process, pid, _reason}, state) do
    IO.puts ":DOWN"
    {name, refs} = Map.pop(state.refs, ref)
    :ets.delete(state.names, name)
    GenEvent.sync_notify(state.events, {:exit, name, pid})
    {:noreply, %{state | refs: refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end