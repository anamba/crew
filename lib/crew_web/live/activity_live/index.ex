defmodule CrewWeb.ActivityLive.Index do
  use CrewWeb, :live_view

  alias Crew.{Activities, Activities.Activity}

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session(socket, session)
    {:ok, assign_new(socket, :activities, fn -> list_activities(socket.assigns.site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    activity = Activities.get_activity!(id)

    socket
    |> assign(:page_title, "Editing: #{activity.name}")
    |> assign(:activity, activity)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New #{gettext("Activity")}")
    |> assign(:activity, %Activity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Activities"))
    |> assign(:activity, nil)
  end

  defp list_activities(site_id) do
    Activities.list_activities(site_id)
  end
end
