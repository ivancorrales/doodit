defmodule Doodit.Region.Supervisor do
  use Supervisor

  
  @event_manager Doodit.EventManager

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end  
  
  def init(:ok) do
    children = [  
      worker(Doodit.Region, [], restart: :temporary),
      #worker(Doodit.Region.LoggerEventHandlerWatcher, [@event_manager, [name: Doodit.Region.LoggerEventHandlerWatcher]])
    ]
    supervise(children, strategy: :one_for_one)
  end

  def start_region(supervisor) do
    IO.puts "start_region"
    IO.puts "#{inspect supervisor}"
    import Supervisor.Spec
    Supervisor.start_child(supervisor, worker(Doodit.Region, [], [id: :foo]))
  end

end