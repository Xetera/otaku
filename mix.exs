defmodule Otaku.MixProject do
  use Mix.Project

  def project do
    [
      app: :otaku,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:jwt, :plug_cowboy, :poison],
      extra_applications: [:logger],
      mod: { Otaku.Server, [] }
    ]
  end

  defp deps do
    [
      { :distillery, "~> 1.5.2" },
      { :plug_cowboy, "~> 1.0" },
      { :cowboy, "~> 1.0.3" },
      { :plug, "~> 1.5" },
      { :poison, "~> 3.0" },
      { :httpoison, "~> 1.4" },
      { :jwt, git: "https://github.com/amezcua/jwt-google-tokens.git", branch: "master" }
    ]
  end
end
