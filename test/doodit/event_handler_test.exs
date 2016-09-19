defmodule Doodit.EventHandlerTest do
  use ExUnit.Case, async: true



  test "handles events" do
    {:ok, manager_pid} = GenEvent.start_link
    #GenEvent.add_handler(manager_pid, Doodit.EventHandler, [])
    #IO.puts "thow event.."
    #IO.puts "#{inspect manager_pid}"
    #result = GenEvent.notify(manager_pid, {:launch, "azure"})
    #IO.puts "#{inspect result}"
  end

end