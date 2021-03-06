import Config

# Configure your database
config :crew, Crew.Repo,
  username: "root",
  password: "",
  database: "crew_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :crew, CrewWeb.Endpoint,
  http: [port: 4000],
  url: [host: System.get_env("HOST", "crew.lvh.me"), port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    mix: ["test.watch", "--stale"],
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :crew, CrewWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/crew_web/(live|views)/.*(ex)$",
      ~r"lib/crew_web/templates/.*(eex)$"
    ]
  ]

config :crew, Crew.Mailer, adapter: Bamboo.LocalAdapter

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :os_mon,
  start_cpu_sup: false,
  start_disksup: false,
  start_memsup: false
