import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :crew, Crew.Repo,
  username: "root",
  password: "",
  database: "crew_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :crew, Crew.Mailer, adapter: Bamboo.LocalAdapter

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crew, CrewWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :os_mon,
  start_cpu_sup: false,
  start_disksup: false,
  start_memsup: false
