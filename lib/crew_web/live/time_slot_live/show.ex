defmodule CrewWeb.TimeSlotLive.Show do
  use CrewWeb, :live_view

  alias Crew.TimeSlots

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_from_session(socket, session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    time_slot = TimeSlots.get_time_slot!(id)
    time_slots = TimeSlots.list_time_slots_in_batch(time_slot.batch_id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, time_slot))
     |> assign(:time_slot, time_slot)
     |> assign(:time_slots, time_slots)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    time_slot = TimeSlots.get_time_slot!(id)
    {:ok, _} = TimeSlots.delete_time_slot(time_slot)

    {:noreply, push_redirect(socket, Routes.time_slot_index_path(socket, :index))}
  end

  defp page_title(:show, time_slot), do: time_slot.name
  defp page_title(:edit, time_slot), do: "Editing: #{time_slot.name}"
end
