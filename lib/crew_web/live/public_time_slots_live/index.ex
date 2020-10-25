defmodule CrewWeb.PublicTimeSlotsLive.Index do
  use CrewWeb, :live_view

  alias Crew.Activities
  alias Crew.Signups

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session_with_person(socket, session)
    Activities.subscribe(socket.assigns.site_id)

    socket =
      socket
      |> assign_new(:time_slots, fn -> Activities.list_time_slots(socket.assigns.site_id) end)
      |> assign_new(:signups, fn -> list_signups(socket) end)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Available #{gettext("Time Slots")}")
  end

  def apply_action(socket, :confirm, _params) do
    socket
    |> assign(:page_title, "Thanks for signing up!")
  end

  @impl true
  def handle_event("create_signup", %{"time-slot-id" => id}, socket) do
    attrs = %{guest_id: socket.assigns.current_person.id, time_slot_id: id}

    case Signups.create_signup(attrs, socket.assigns.site_id) do
      {:ok, signup} ->
        {:noreply,
         socket
         |> assign(:signup_id, signup.id)
         |> assign(:signups, list_signups(socket))
         |> push_patch(to: Routes.public_time_slots_index_path(socket, :confirm))}

      {:error, changeset} ->
        messages = Enum.map_join(changeset.errors, "; ", &elem(elem(&1, 1), 0))
        {:noreply, put_flash(socket, :info, "An error occured: #{messages}")}
    end
  end

  @impl true
  def handle_event("cancel", %{"id" => signup_id}, socket) do
    signup = Signups.get_signup!(signup_id)
    Signups.delete_signup(signup)

    {:noreply, assign(socket, :signups, list_signups(socket))}
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

  defp list_signups(socket),
    do: Signups.list_signups_for_guest(socket.assigns.current_person.id, true)
end
