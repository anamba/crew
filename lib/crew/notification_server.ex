defmodule Crew.NotificationServer do
  use GenServer
  require Logger

  alias Crew.Persons

  #####
  # External API
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  #####
  # GenServer implementation
  def init(_state) do
    state = %{}

    unless System.get_env("NO_NOTIFICATION_SERVER") do
      # watch for exiting child processes
      Process.flag(:trap_exit, true)

      # wake up every 1m to process queue
      :timer.send_interval(60_000, self(), :update)

      # run initial check right away
      # send(self(), :update)
    end

    {:ok, state}
  end

  def handle_info(:update, state) do
    Logger.info("[Notification Server] polling for notifications")
    IO.inspect(state, label: "State")

    Persons.list_email_notifications(5)
    # |> IO.inspect()
    |> Enum.group_by(& &1.person)
    |> Enum.map(fn {person, notifications} ->
      if String.trim(person.email || "") != "" do
        CrewWeb.PersonEmail.notification(person, notifications)
        |> Crew.Mailer.deliver_later()

        Enum.each(notifications, &Persons.mark_notification_sent/1)
      else
        Enum.each(notifications, &Persons.skip_notification/1)
      end
    end)

    {:noreply, state}
  end
end
