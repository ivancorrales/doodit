defmodule Doodit.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    ets = :ets.new(:registry_table, [:set, :public])
    {:ok, registry: start_registry(ets), ets: ets}
  end

  defp start_registry(ets) do
    {:ok, sup} = Doodit.Region.Supervisor.start_link
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = Doodit.Registry.start_link(ets, manager, sup)
    #GenEvent.add_mon_handler(manager, Forwarder, self())
    registry
  end

  test "spawns regions", %{registry: registry, ets: ets}do
    assert Doodit.Registry.lookup(ets, "digitalocean") == :error
    Doodit.Registry.create(registry, "digitalocean")
    assert {:ok, region} = Doodit.Registry.lookup(ets, "digitalocean")
    Doodit.Region.put(region, "node1", 1)
    assert Doodit.Region.get(region, "node1") == 1
    Process.exit(region, :shutdown)
    #assert_receive {:EXIT, ^region, :shutdown}
    #refute_received {:terminate, _}

    #Doodit.Region.get(region, "node1")
  end
end