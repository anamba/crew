defmodule Crew.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      children_for_env(Mix.env()) ++
        [
          # Start the Ecto repository
          Crew.Repo,
          # Start the Telemetry supervisor
          CrewWeb.Telemetry,
          # Start the PubSub system
          {Phoenix.PubSub, name: Crew.PubSub},
          # Start the Endpoint (http/https)
          CrewWeb.Endpoint
          # Start a worker by calling: Crew.Worker.start_link(arg)
          # {Crew.Worker, arg}
        ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crew.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def children_for_env(:dev) do
    if System.get_env("NO_ELASTICSEARCH") do
      []
    else
      [
        {MuonTrap.Daemon, ["elasticsearch", [], [env: %{"ES_JAVA_OPTS" => "-Xms64m -Xmx64m"}]]}
      ]
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
