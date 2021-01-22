defmodule CrewWeb.TimeSlotLive.FormComponent do
  use CrewWeb, :live_component

  import Ecto.Changeset
  alias Crew.TimeSlots
  alias Crew.Persons

  @impl true
  def update(%{time_slot: time_slot} = assigns, socket) do
    changeset = TimeSlots.change_time_slot_batch(time_slot)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign_from_changeset(changeset)}
  end

  defp assign_from_changeset(socket, changeset) do
    activity_ids = get_change(changeset, :activity_ids) || [get_field(changeset, :activity_id)]

    tag = Persons.get_person_tag(get_field(changeset, :person_tag_id))

    socket =
      case tag && tag.value_choices_json && Jason.decode(tag.value_choices_json) do
        {:ok, choices} -> assign(socket, :person_tag_value_choices, choices)
        _ -> assign(socket, :person_tag_value_choices, nil)
      end

    socket
    |> assign_new(:original_activity_ids, fn -> activity_ids end)
    |> assign_new(:remove_from_batch, fn -> length(activity_ids) == 1 end)
    |> assign(:activity_ids, activity_ids)
    |> assign(:person_tag, tag)
  end

  @impl true
  def handle_event("validate", %{"time_slot" => time_slot_params}, socket) do
    {socket, time_slot_params} =
      if socket.assigns.remove_from_batch do
        time_slot =
          TimeSlots.get_slot_by_batch_id_and_activity_id(
            socket.assigns.time_slot.batch_id,
            time_slot_params["single_activity_id"] ||
              List.first(socket.assigns.original_activity_ids)
          )

        if time_slot && time_slot != socket.assigns.time_slot do
          {assign(socket, :time_slot, time_slot),
           Map.put(time_slot_params, "activity_id", time_slot.activity_id)}
        else
          {socket, time_slot_params}
        end
      else
        {socket, time_slot_params}
      end

    changeset =
      socket.assigns.time_slot
      |> TimeSlots.change_time_slot_batch(time_slot_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign_from_changeset(changeset)}
  end

  def handle_event("remove_from_batch", _, socket) do
    {:noreply, assign(socket, :remove_from_batch, true)}
  end

  def handle_event("return_to_batch", _, socket) do
    {:noreply, assign(socket, :remove_from_batch, false)}
  end

  def handle_event("save", %{"time_slot" => time_slot_params}, socket) do
    save_time_slot(socket, socket.assigns.action, time_slot_params)
  end

  defp save_time_slot(socket, :edit, time_slot_params) do
    if socket.assigns.remove_from_batch do
      time_slot =
        TimeSlots.get_slot_by_batch_id_and_activity_id(
          socket.assigns.time_slot.batch_id,
          time_slot_params["single_activity_id"]
        )

      time_slot_params =
        if length(socket.assigns.activity_ids) != 1 do
          time_slot_params
          |> Map.put("batch_id", "")
          |> Map.put("activity_ids", [time_slot_params["activity_id"]])
        else
          time_slot_params
        end

      case TimeSlots.update_time_slot(time_slot, time_slot_params) do
        {:ok, _time_slot} ->
          {:noreply,
           socket
           |> put_flash(:info, "#{gettext("Time Slot")} updated successfully")
           |> push_redirect(to: socket.assigns.return_to)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    else
      case TimeSlots.update_time_slot_batch(socket.assigns.time_slot, time_slot_params) do
        {:ok, _time_slot} ->
          {:noreply,
           socket
           |> put_flash(:info, "#{gettext("Time Slot")} updated successfully")
           |> push_redirect(to: socket.assigns.return_to)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    end
  end

  defp save_time_slot(socket, :new, time_slot_params) do
    # extract out the ids
    case TimeSlots.create_time_slot_batch(time_slot_params, socket.assigns.site_id) do
      {:ok, _time_slot} ->
        {:noreply,
         socket
         |> put_flash(:info, "#{gettext("Time Slot")} created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
