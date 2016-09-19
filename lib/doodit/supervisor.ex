defmodule Doodit.Supervisor do
  use Supervisor


  @manager_watcher_name Doodit.EventHandlerWatcher
  @manager_name Doodit.EventManager
  @registry_name Doodit.Registry
  @region_supervisor_name Doodit.Region.Supervisor
  @ets_registry_name Doodit.Registry

  def start_link  do
    IO.puts "start_link"
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    IO.puts "-----------------------------"
    ets = :ets.new(@ets_registry_name,
                   [:set, :public, :named_table, {:read_concurrency, true}])

    children = [ 
      worker(Doodit.EventManager, [name: @manager_name]),
      supervisor(Doodit.Region.Supervisor, [[name: @region_supervisor_name]]),
      worker(Doodit.Registry, [ets, @manager_name, @region_supervisor_name, [name: @registry_name]]),
      worker(@manager_watcher_name,[Doodit.EventHandler,Doodit.EventManager,[]])
    ]
    supervise(children, strategy: :one_for_one)
  end

end