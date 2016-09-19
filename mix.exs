defmodule Doodit.Mixfile do
  use Mix.Project

  def project do
    [app: :doodit,
     version: "0.1.0",
     elixir: "~> 1.3",
     #escript: [main_module: Doodit],
     deps: deps()]
  end

  def application do
    [
      applications: [:logger, :cowboy],
      mod: {Doodit,[]}
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:cowboy, "1.0.4"},
      {:plug, "1.2.0"}
    ]
  end
end
