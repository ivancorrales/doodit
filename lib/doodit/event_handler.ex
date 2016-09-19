defmodule Doodit.EventHandler do
  use GenEvent
  require Logger

  def handle_event({:create, name, manager}, parent) do
    Logger.info("create event received:  name: #{name}, manager:#{inspect manager} and parent:#{inspect parent}")
    {:ok, parent}
  end


  def handle_event({:exit, name, manager}, parent) do
    Logger.info("exit event received:  name: #{name}, manager:#{inspect manager} and parent:#{inspect parent}")
    {:ok, parent}
  end

  def handle_event(event, parent) do
    Logger.info("create event #{inspect event} and parent:#{inspect parent}")
    {:ok, parent}
  end

end