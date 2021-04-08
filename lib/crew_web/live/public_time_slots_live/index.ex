defmodule CrewWeb.PublicTimeSlotsLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Signups
  alias Crew.TimeSlots
  alias Crew.TimeSlots.TimeSlot

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
        |> assign_new(:show_filters, fn -> false end)

      socket =
        assign(socket, :selected_person_ids, [
          socket.assigns.current_person.id | Enum.map(socket.assigns.related_persons, & &1.id)
        ])

      socket =
        if socket.assigns[:time_slots] do
          socket
        else
          update_time_slot_list(socket)
        end

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

    {:noreply, update_time_slot_list(socket)}
  end

  def handle_event("set_selected_persons", _, socket) do
    all_person_ids =
      [socket.assigns.current_person | socket.assigns.related_persons] |> Enum.map(& &1.id)

    next_person_id = (all_person_ids -- socket.assigns.selected_person_ids) |> List.first()
    socket = assign(socket, :selected_person_ids, [next_person_id])
    {:noreply, update_time_slot_list(socket)}
  end

  @impl true
  def handle_event("show_filters", _params, socket) do
    {:noreply, assign(socket, :show_filters, true)}
  end

  @impl true
  def handle_event("set_filters", params, socket) do
    socket = assign(socket, :show_unavailable, params["show_unavailable"])

    activity_checkbox_map =
      for activity <- socket.assigns.activities, into: %{} do
        key = "show_activity_#{activity.id}"
        {key, params[key]}
      end

    socket = assign(socket, activity_checkbox_map)

    {:noreply, update_time_slot_list(socket)}
  end

  def handle_event("set_time_range", params, socket) do
    socket =
      socket
      |> assign(:time_range_start, String.to_integer(params["time_range_start"]))
      |> assign(:time_range_end, String.to_integer(params["time_range_end"]))

    {:noreply, update_time_slot_list(socket)}
  end

  def handle_event("select_all_activities", _params, socket) do
    activity_checkbox_map =
      for activity <- socket.assigns.activities, into: %{} do
        key = "show_activity_#{activity.id}"
        {key, true}
      end

    socket = assign(socket, activity_checkbox_map)

    {:noreply, update_time_slot_list(socket)}
  end

  def handle_event("deselect_all_activities", _params, socket) do
    activity_checkbox_map =
      for activity <- socket.assigns.activities, into: %{} do
        key = "show_activity_#{activity.id}"
        {key, false}
      end

    socket = assign(socket, activity_checkbox_map)

    {:noreply, update_time_slot_list(socket)}
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
        {:noreply, put_flash(socket, :error, messages)}
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

  defp update_time_slot_list(socket) do
    time_slots =
      TimeSlots.list_future_time_slots_for_persons_ids(
        socket.assigns.selected_person_ids,
        socket.assigns[:show_unavailable]
      )

    {time_range_min, time_range_max} =
      time_slots
      |> Enum.flat_map(&[&1.start_time, &1.end_time])
      |> Enum.min_max(fn ->
        {socket.assigns[:time_range_min], socket.assigns[:time_range_max]}
      end)

    time_range_min =
      case time_range_min do
        nil -> 0
        millis when is_integer(millis) -> millis
        dt -> DateTime.to_unix(dt, :millisecond)
      end

    time_range_max =
      case time_range_max do
        nil -> :math.pow(2, 32) |> round
        millis when is_integer(millis) -> millis
        dt -> DateTime.to_unix(dt, :millisecond)
      end

    activities =
      time_slots
      |> Enum.map(& &1.activity)
      |> Enum.uniq()
      |> Enum.sort_by(& &1.name)

    filtered_activity_map =
      for activity <- activities, into: %{} do
        key = "show_activity_#{activity.id}"

        if Map.has_key?(socket.assigns, key) do
          {activity.id, socket.assigns[key]}
        else
          {activity.id, true}
        end
      end

    activity_checkboxes =
      Enum.map(filtered_activity_map, fn {activity_id, _} ->
        {"show_activity_#{activity_id}", filtered_activity_map[activity_id]}
      end)

    time_slots =
      with range_start_i when range_start_i > 0 <- socket.assigns[:time_range_start] || 0,
           range_end_i when range_end_i > 0 <- socket.assigns[:time_range_end] || 0,
           {:ok, range_start} = DateTime.from_unix(range_start_i, :millisecond),
           {:ok, range_end} = DateTime.from_unix(range_end_i, :millisecond) do
        Enum.filter(
          time_slots,
          &(DateTime.compare(range_start, &1.start_time) in [:lt, :eq] &&
              DateTime.compare(&1.end_time, range_end) in [:lt, :eq])
        )
      else
        _ -> time_slots
      end

    time_slots = Enum.filter(time_slots, &filtered_activity_map[&1.activity_id])

    socket
    |> assign(:time_slots, time_slots)
    |> assign(:activities, activities)
    |> assign(:time_range_min, time_range_min)
    |> assign(:time_range_max, time_range_max)
    |> assign_new(:time_range_start, fn -> time_range_min end)
    |> assign_new(:time_range_end, fn -> time_range_max end)
    |> assign(activity_checkboxes)
  end

  defp list_signups(socket),
    do: Signups.list_signups_for_guest(socket.assigns.current_person.id, true)
end
