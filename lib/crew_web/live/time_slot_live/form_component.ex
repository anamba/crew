defmodule CrewWeb.TimeSlotLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Activities

  @impl true
  def update(%{time_slot: time_slot} = assigns, socket) do
    changeset = Activities.change_time_slot(time_slot)
    activity_ids = Ecto.Changeset.get_change(changeset, :activity_ids)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:activity_ids, activity_ids)
     |> assign(:remove_from_batch, length(activity_ids) == 1)}
  end

  @impl true
  def handle_event("validate", %{"time_slot" => time_slot_params}, socket) do
    changeset =
      socket.assigns.time_slot
      |> Activities.change_time_slot(time_slot_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:activity_ids, Ecto.Changeset.get_change(changeset, :activity_ids))}
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
    case Activities.update_time_slot(socket.assigns.time_slot, time_slot_params) do
      {:ok, _time_slot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Time Slot updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_time_slot(socket, :new, time_slot_params) do
    # extract out the ids
    case Activities.create_time_slot(time_slot_params, socket.assigns.site_id) do
      {:ok, _time_slot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Time Slot created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
