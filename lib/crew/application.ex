defmodule Crew.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      children_for_env(System.get_env("MIX_ENV", "dev")) ++
        [
          Crew.Repo,
          CrewWeb.Telemetry,
          {Phoenix.PubSub, name: Crew.PubSub},
          CrewWeb.Endpoint,
          Crew.NotificationServer
        ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crew.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def children_for_env("dev") do
    if System.get_env("NO_ELASTICSEARCH") do
      []
    else
      [{MuonTrap.Daemon, ["elasticsearch", [], [env: %{"ES_JAVA_OPTS" => "-Xms64m -Xmx64m"}]]}]
    end
  end

  def children_for_env(_), do: []

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CrewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
