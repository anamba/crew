import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

sentry_dsn =
  System.get_env("SENTRY_DSN") ||
    raise """
    environment variable SENTRY_DSN is missing.
    """

config :crew, Crew.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :crew, CrewWeb.Endpoint,
  server: true,
  get_port_from_system_env: true,
  url: [host: System.get_env("HOST", "crew-app.com"), port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: ["https://*.crew-app.com", "https://*.biggerbird.com"],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# Do not print debug messages in production
config :logger,
  level: :info,
  backends: [:console, Sentry.LoggerBackend]

if System.get_env("USE_BAMBOO_LOCAL_ADAPTER") do
  config :crew, Crew.Mailer, adapter: Bamboo.LocalAdapter
else
  config :crew, Crew.Mailer,
    adapter: Bamboo.PostmarkAdapter,
    api_key: System.get_env("POSTMARK_API_TOKEN")
end

config :sentry,
  dsn: sentry_dsn,
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{env: "production"},
  included_environments: [:prod]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :crew, CrewWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :crew, CrewWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.
