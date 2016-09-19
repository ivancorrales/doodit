defmodule Doodit.Region.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def start_region(supervisor) do
    Supervisor.start_child(supervisor, [])
  end

  def init(:ok) do
    children = [
      worker(Doodit.Region, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end