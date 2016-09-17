defmodule Doodit.Commands do

  defstruct command: ""

  defmacro is_valid_response?(command) do
   	quote do: unquote(command) in ["run","debug"] 
  end


end