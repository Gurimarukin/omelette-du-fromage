defmodule Scrapers.MixProject do
  use Mix.Project

  def project do
    [
      app: :scrapers,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger],
      mod: {Scrapers.Application, []}
    ]
  end

  defp deps do
    [
      {:rate_limiter, in_umbrella: true},
      {:shows_store, in_umbrella: true},
      {:httpoison, "~> 1.5"},
      {:floki, "~> 0.21"},
      {:hound, "~> 1.0"}
    ]
  end
end
