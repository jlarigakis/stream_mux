defmodule StreamMux.Mixfile do
  use Mix.Project

  def project do
    [
      app: :stream_mux,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  def escript do
    [main_module: StreamMux]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:cowboy, :plug, :porcelain],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.0"},
      {:porcelain, "~> 2.0"}
    ]
  end
end
