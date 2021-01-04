defmodule CrewWeb.PersonLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Persons

  @impl true
  def update(%{person: person} = assigns, socket) do
    changeset = Persons.change_person(person)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      socket.assigns.person
      |> Persons.change_person(person_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  def handle_event("destroy", _params, socket) do
    case Persons.delete_person(socket.assigns.person) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "#{gettext("Person")} deleted successfully")
         |> push_redirect(to: Routes.person_index_path(socket, :index))}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "An error occurred")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp save_person(socket, :edit, person_params) do
    case Persons.update_person(socket.assigns.person, person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "#{gettext("Person")}  updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_person(socket, :new, person_params) do
    case Persons.create_person(person_params, socket.assigns.site_id) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "#{gettext("Person")}  created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
