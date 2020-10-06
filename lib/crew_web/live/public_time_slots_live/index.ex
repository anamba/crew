defmodule CrewWeb.PublicTimeSlotsLive.Index do
  use CrewWeb, :live_view

  alias Crew.Activities
  alias Crew.Signups

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session_with_person(socket, session)
    Activities.subscribe(socket.assigns.site_id)

    {:ok, assign(socket, :time_slots, Crew.Activities.list_time_slots(socket.assigns.site_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("create_signup", %{"time-slot-id" => id}, socket) do
    {:ok, signup} =
      Signups.create_signup(
        %{guest_id: socket.assigns.current_person.id, time_slot_id: id},
        socket.assigns.site_id
      )

    {:noreply,
     socket
     |> assign(:signup_id, signup.id)
     |> push_patch(to: Routes.public_time_slots_index_path(socket, :confirm))}
  end

  @impl true
  def handle_info({Activities, "time_slot-changed", time_slot}, socket) do
    {:noreply,
     assign(socket, :time_slots, update_time_slot(socket.assigns.time_slots, time_slot))}
  end

  defp update_time_slot(time_slots, new_time_slot) do
    if Enum.any?(time_slots, &(&1.id == new_time_slot.id)) do
      # updating existing
      Enum.map(time_slots, fn original_time_slot ->
        if original_time_slot.id == new_time_slot.id,
          do: new_time_slot,
          else: original_time_slot
      end)
    else
      # adding new
      time_slots ++ [new_time_slot]
    end
  end

  def apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Available #{gettext("Time Slots")}")
  end

  def apply_action(socket, :confirm, _params) do
    socket
    |> assign(:page_title, "Confirm Your #{gettext("Signups")}")
  end
end
