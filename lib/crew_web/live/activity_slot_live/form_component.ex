defmodule CrewWeb.ActivitySlotLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Activities

  @impl true
  def update(%{activity_slot: activity_slot} = assigns, socket) do
    changeset = Activities.change_activity_slot(activity_slot)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity_slot" => activity_slot_params}, socket) do
    changeset =
      socket.assigns.activity_slot
      |> Activities.change_activity_slot(activity_slot_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"activity_slot" => activity_slot_params}, socket) do
    save_activity_slot(socket, socket.assigns.action, activity_slot_params)
  end

  defp save_activity_slot(socket, :edit, activity_slot_params) do
    case Activities.update_activity_slot(socket.assigns.activity_slot, activity_slot_params) do
      {:ok, _activity_slot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity slot updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_activity_slot(socket, :new, activity_slot_params) do
    case Activities.create_activity_slot(activity_slot_params) do
      {:ok, _activity_slot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity slot created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
