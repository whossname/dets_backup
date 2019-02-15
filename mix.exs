defmodule DetsBackup.MixProject do
  use Mix.Project

  def project do
    [
      app: :dets_backup,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_azure, github: "azukiapp/ex_azure"},

      {:mock, "~> 0.3.0", only: :test},
    ]
  end
end
