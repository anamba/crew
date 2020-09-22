defmodule CrewWeb.ActivityTagGroupLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Activities

  @impl true
  def update(%{activity_tag_group: activity_tag_group} = assigns, socket) do
    changeset = Activities.change_activity_tag_group(activity_tag_group)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity_tag_group" => activity_tag_group_params}, socket) do
    changeset =
      socket.assigns.activity_tag_group
      |> Activities.change_activity_tag_group(activity_tag_group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"activity_tag_group" => activity_tag_group_params}, socket) do
    save_activity_tag_group(socket, socket.assigns.action, activity_tag_group_params)
  end

  defp save_activity_tag_group(socket, :edit, activity_tag_group_params) do
    case Activities.update_activity_tag_group(
           socket.assigns.activity_tag_group,
           activity_tag_group_params
         ) do
      {:ok, _activity_tag_group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity tag group updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_activity_tag_group(socket, :new, activity_tag_group_params) do
    case Activities.create_activity_tag_group(activity_tag_group_params, socket.assigns.site_id) do
      {:ok, _activity_tag_group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity tag group created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
