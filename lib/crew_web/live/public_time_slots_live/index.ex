defmodule CrewWeb.PublicTimeSlotsLive.Index do
  use CrewWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_from_session_with_person(socket, session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Available #{gettext("Time Slots")}")
    |> assign(:time_slots, Crew.Activities.list_time_slots(socket.assigns.site_id))
  end
end
