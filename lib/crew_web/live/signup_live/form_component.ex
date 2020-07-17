defmodule CrewWeb.SignupLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Signups

  @impl true
  def update(%{signup: signup} = assigns, socket) do
    changeset = Signups.change_signup(signup)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"signup" => signup_params}, socket) do
    changeset =
      socket.assigns.signup
      |> Signups.change_signup(signup_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"signup" => signup_params}, socket) do
    save_signup(socket, socket.assigns.action, signup_params)
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
    case Signups.create_signup(signup_params) do
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
