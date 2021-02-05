defmodule CrewWeb.PublicTimeSlotsLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Signups
  alias Crew.TimeSlots

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session_with_person(socket, session)

    if socket.assigns[:current_person] do
      TimeSlots.subscribe(socket.assigns.site_id)

      socket =
        socket
        |> assign_new(:signups, fn ->
          Signups.list_signups_for_guest(socket.assigns.current_person.id, true)
        end)
        # FIXME: hardcoded to Spouse relationships for now, but eventually this will be configurable
        |> assign_new(:related_persons, fn ->
          Persons.list_persons_related_to_person_id(socket.assigns.current_person.id, "Spouse")
        end)

      socket =
        assign(socket, :selected_person_ids, [
          socket.assigns.current_person.id | Enum.map(socket.assigns.related_persons, & &1.id)
        ])

      socket = assign_new(socket, :time_slots, fn -> list_time_slots(socket) end)

      {:ok, socket}
    else
      {:ok, socket}
    end
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
  def handle_event("set_selected_persons", %{"selected_persons" => ids}, socket) do
    socket = assign(socket, :selected_person_ids, ids)

    {:noreply, assign(socket, :time_slots, list_time_slots(socket))}
  end

  def handle_event("set_selected_persons", _, socket) do
    all_person_ids =
      [socket.assigns.current_person | socket.assigns.related_persons] |> Enum.map(& &1.id)

    next_person_id = (all_person_ids -- socket.assigns.selected_person_ids) |> List.first()
    socket = assign(socket, :selected_person_ids, [next_person_id])
    {:noreply, assign(socket, :time_slots, list_time_slots(socket))}
  end

  @impl true
  def handle_event("set_filters", params, socket) do
    socket = assign(socket, :show_unavailable, params["show_unavailable"])
    {:noreply, assign(socket, :time_slots, list_time_slots(socket))}
  end

  @impl true
  def handle_event("create_signup", %{"time-slot-id" => id}, socket) do
    attrs = %{time_slot_id: id}

    case Signups.create_linked_signups(
           attrs,
           socket.assigns.selected_person_ids,
           socket.assigns.site_id
         ) do
      [{:ok, signup} | _rest] ->
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
  def handle_info({TimeSlots, "time_slot-changed", time_slot}, socket) do
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

  defp list_time_slots(socket) do
    TimeSlots.list_future_time_slots_for_persons_ids(
      socket.assigns.selected_person_ids,
      socket.assigns[:show_unavailable]
    )
  end

  defp list_signups(socket),
    do: Signups.list_signups_for_guest(socket.assigns.current_person.id, true)
end
