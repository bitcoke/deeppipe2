defmodule Deeppipe2.MixProject do
  use Mix.Project
  

  def project do
    [
      app: :deeppipe2,
      version: "1.0.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: [:makecuda] ++ Mix.compilers,
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
      {:matrex, "~> 0.6"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end


defmodule Mix.Tasks.Compile.Makecuda do
  use Mix.Task

  def run(_) do
    Mix.shell.cmd "make"
    :ok
  end 
end