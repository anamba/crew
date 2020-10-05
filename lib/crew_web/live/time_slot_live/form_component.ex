defmodule CrewWeb.TimeSlotLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Activities

  @impl true
  def update(%{time_slot: time_slot} = assigns, socket) do
    changeset = Activities.change_time_slot_batch(time_slot)

    activity_ids =
      Ecto.Changeset.get_change(changeset, :activity_ids) ||
        [Ecto.Changeset.get_field(changeset, :activity_id)]

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:original_activity_ids, activity_ids)
     |> assign(:activity_ids, activity_ids)
     |> assign(:remove_from_batch, length(activity_ids) == 1)}
  end

  @impl true
  def handle_event("validate", %{"time_slot" => time_slot_params}, socket) do
    {socket, time_slot_params} =
      if socket.assigns.remove_from_batch do
        # look through the batch to find the target slot to modify (the one with the selected activity id)
        batch_id = socket.assigns.time_slot.batch_id
        batch = Crew.Activities.list_time_slots_in_batch(batch_id)

        time_slot =
          batch
          |> Enum.filter(&(&1.activity_id == time_slot_params["single_activity_id"]))
          |> List.first()

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
      |> Activities.change_time_slot_batch(time_slot_params)
      |> Map.put(:action, :validate)

    activity_ids =
      Ecto.Changeset.get_change(changeset, :activity_ids) ||
        [Ecto.Changeset.get_field(changeset, :activity_id)]

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:activity_ids, activity_ids)}
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
      # look through the batch to find the target slot to modify (the one with the selected activity id)
      batch_id = socket.assigns.time_slot.batch_id
      batch = Crew.Activities.list_time_slots_in_batch(batch_id)

      time_slot =
        batch
        |> Enum.filter(&(&1.activity_id == time_slot_params["single_activity_id"]))
        |> List.first()

      time_slot_params =
        if length(socket.assigns.activity_ids) != 1 do
          time_slot_params
          |> Map.put("batch_id", "")
          |> Map.put("activity_ids", [time_slot_params["activity_id"]])
        else
          time_slot_params
        end

      case Activities.update_time_slot(time_slot, time_slot_params) do
        {:ok, _time_slot} ->
          {:noreply,
           socket
           |> put_flash(:info, "#{gettext("Time Slot")} updated successfully")
           |> push_redirect(to: socket.assigns.return_to)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    else
      case Activities.update_time_slot_batch(socket.assigns.time_slot, time_slot_params) do
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
    case Activities.create_time_slot_batch(time_slot_params, socket.assigns.site_id) do
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
