defmodule CrewWeb.Endpoint do
  use Sentry.PlugCapture
  use Phoenix.Endpoint, otp_app: :crew

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_crew_key",
    signing_salt: "IZIq5hyR"
  ]

  socket "/socket", CrewWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :crew,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :crew
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Sentry.PlugContext
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CrewWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    config =
      if config[:get_port_from_system_env] do
        port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
        Keyword.put(config, :http, [:inet6, port: port])
      else
        config
      end

    # wait_for_tcp_port(
    #   Application.get_env(:crew, :elasticsearch_host),
    #   Application.get_env(:crew, :elasticsearch_port)
    # )

    {:ok, config}
  end

  # defp wait_for_tcp_port(hostname, port, attempt \\ 1) do
  #   case :gen_tcp.connect(hostname |> String.to_charlist(), port, [], 1000) do
  #     {:ok, _} ->
  #       :ok

  #     {:error, err} ->
  #       if attempt < 60 do
  #         if attempt > 10,
  #           do:
  #             IO.puts(
  #               "Could not connect to Elasticsearch at #{hostname}:#{port} (#{err}), retrying."
  #             )

  #         Process.sleep(1000)
  #         wait_for_tcp_port(hostname, port, attempt + 1)
  #       else
  #         raise "Could not connect to Elasticsearch at #{hostname}:#{port} after #{attempt} attempts."
  #       end
  #   end
  # end
end
