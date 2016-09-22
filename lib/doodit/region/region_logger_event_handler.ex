defmodule Doodit.Region.LoggerEventHandler do
  use GenEvent
  require Logger

  
  def init(_), do: {:ok, {}}

  def handle_event({:log, x}, messages) do
    Logger.info(x)
    {:ok, [x|messages]}
  end



end