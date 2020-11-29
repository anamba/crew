defmodule Crew.MixProject do
  use Mix.Project

  def project do
    [
      app: :crew,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Crew.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.3"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.14"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:myxql, ">= 0.0.0"},
      {:plug_cowboy, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:bcrypt_elixir, "~> 2.0"},
      {:pwned, "~> 1.1"},
      {:nimble_totp, "~> 0.1.0"},
      {:eqrcode, "~> 0.1.7"},
      # {:nebulex, "~> 1.2"},
      {:canada, "~> 2.0"},
      {:timex, "~> 3.6"},
      {:elastix, "~> 0.8"},
      {:bamboo, "~> 1.6"},
      {:bamboo_postmark, "~> 0.6"},
      {:xlsxir, "~> 1.6.4"},
      {:sentry, "~> 8.0"},
      {:muontrap, "~> 0.6"},
      # {:phx_gen_auth, "~> 0.4.0", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev], runtime: false},
      {:floki, "~> 0.24", only: [:test]},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
