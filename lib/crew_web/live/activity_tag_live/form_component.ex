defmodule CrewWeb.ActivityTagLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Activities

  @impl true
  def update(%{activity_tag: activity_tag} = assigns, socket) do
    changeset = Activities.change_activity_tag(activity_tag)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity_tag" => activity_tag_params}, socket) do
    changeset =
      socket.assigns.activity_tag
      |> Activities.change_activity_tag(activity_tag_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"activity_tag" => activity_tag_params}, socket) do
    save_activity_tag(socket, socket.assigns.action, activity_tag_params)
  end

  defp save_activity_tag(socket, :edit, activity_tag_params) do
    case Activities.update_activity_tag(socket.assigns.activity_tag, activity_tag_params) do
      {:ok, _activity_tag} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity tag updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_activity_tag(socket, :new, activity_tag_params) do
    case Activities.create_activity_tag(activity_tag_params, socket.assigns.site_id) do
      {:ok, _activity_tag} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity tag created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
