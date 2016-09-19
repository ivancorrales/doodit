defmodule Doodit do

  def start(_type, _args) do
    Doodit.Supervisor.start_link
  end

end
