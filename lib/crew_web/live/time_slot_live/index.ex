defmodule CrewWeb.TimeSlotLive.Index do
  use CrewWeb, :live_view

  alias Crew.Activities
  alias Crew.Activities.TimeSlot

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
    {:ok, assign_new(socket, :time_slots, fn -> list_time_slots(site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit #{gettext("Time Slot")}")
    |> assign(:time_slot, Activities.get_time_slot!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New #{gettext("Time Slot")}")
    |> assign(:time_slot, %TimeSlot{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Time Slots"))
    |> assign(:time_slot, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    time_slot = Activities.get_time_slot!(id)
    {:ok, _} = Activities.delete_time_slot(time_slot)

    {:noreply, assign(socket, :time_slots, list_time_slots(socket.assigns.site_id))}
  end

  defp list_time_slots(site_id) do
    Activities.list_time_slots([:activity, :person, :location], site_id)
  end
end
