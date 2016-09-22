defmodule Doodit.Supervisor do
  use Supervisor

  @region_supervisor Doodit.Region.Supervisor
  @event_manager Doodit.EventManager
  @registry_name Doodit.Registry

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  
  def init(:ok) do
    ets = :ets.new(@registry_name, [:set, :public, {:read_concurrency, true}])    
    children = [ 
      worker(GenEvent, [[name: @event_manager]], [id: @event_manager]),
      supervisor(Doodit.Region.Supervisor, [[name: @region_supervisor]]),
      worker(Doodit.Registry, [ets, @event_manager, @region_supervisor, [name: @registry_name]])
    ]
    supervise(children, strategy: :one_for_one)
  end

end