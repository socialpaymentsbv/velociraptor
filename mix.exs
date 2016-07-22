defmodule Velociraptor.Mixfile do
  use Mix.Project

  def project do
    [app: :velociraptor,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps(),
     docs: [extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:poison, "~> 2.0"},
     {:exvcr, "~> 0.7.4", only: [:dev, :test]}]
  end

  defp package do
    [maintainers: ["Adrian Gruntkowski", "Adam Rutkowski"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/socialpaymentsbv/velociraptor"}]
  end
end
