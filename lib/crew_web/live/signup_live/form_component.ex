defmodule CrewWeb.SignupLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Signups
  alias Crew.Persons

  @impl true
  def update(%{signup: signup} = assigns, socket) do
    changeset = Signups.change_signup(signup)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"signup" => signup_params, "guest_query" => guest_query}, socket) do
    site_id = socket.assigns.site_id

    changeset =
      socket.assigns.signup
      |> Signups.change_signup(signup_params, site_id)
      |> Map.put(:action, :validate)

    socket =
      case guest_query do
        "" -> socket
        query -> assign(socket, :guest_search_results, Persons.search(query, site_id))
      end

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("set_guest_id", params, socket) do
    %{"guest_id" => guest_id} = params

    case Persons.get_person(guest_id) do
      nil ->
        {:noreply, socket}

      guest ->
        signup = Map.put(socket.assigns.signup, :guest, guest)
        {:noreply, assign(socket, signup: signup, guest_search_results: nil)}
    end
  end

  @impl true
  def handle_event("save", %{"signup" => signup_params}, socket) do
    save_signup(socket, socket.assigns.action, signup_params)
  end

  @impl true
  def handle_event("destroy", _params, socket) do
    case Signups.delete_signup(socket.assigns.signup) do
      {:ok, _signup} ->
        {:noreply,
         socket
         |> put_flash(:info, "#{gettext("Signup")} deleted successfully")
         |> push_redirect(to: Routes.signup_index_path(socket, :index))}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "An error occurred")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp save_signup(socket, :edit, signup_params) do
    case Signups.update_signup(socket.assigns.signup, signup_params) do
      {:ok, _signup} ->
        {:noreply,
         socket
         |> put_flash(:info, "Signup updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_signup(socket, :new, signup_params) do
    case Signups.create_signup(signup_params, socket.assigns.site_id) do
      {:ok, _signup} ->
        {:noreply,
         socket
         |> put_flash(:info, "Signup created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
