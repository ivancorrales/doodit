defmodule Doodit do


  def main(args) do
 	 args
 	 |> parse_args
 	 |> process
  end


 def process({command, options}) when command === "run" do
	IO.puts "Ok."	
 end


 def process(_) do
    IO.puts "No valid input"
 end

 defp parse_args(args) do
 	{options, command, c} = OptionParser.parse(args,
 		switches: switches,
 		aliases: aliases
 	)
	IO.puts "#{inspect options} #{inspect command} #{inspect c}"
	{Enum.fetch!(command,0), options}
 end

 defp switches do
 	[config: :string, input: :string, output: :string, verbose: :boolean]
 end	

 defp aliases do
 	[c: :config, i: :input, o: :output, p: :port, v: :verbose]
 end

 

 

end
