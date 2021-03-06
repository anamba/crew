# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :crew,
  ecto_repos: [Crew.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :crew, CrewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "osEnXui2vnS84g4/jV8ZSwRvNbHTNPtfDaLjt3B6nkY5VddLLOUUPdL9yRurLyjh",
  render_errors: [view: CrewWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Crew.PubSub,
  live_view: [signing_salt: "uzL75RS2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Set a valid tz database (to avoid :utc_only_time_zone_database)
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
