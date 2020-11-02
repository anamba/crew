defmodule CrewWeb.PublicSignupLive.ConfirmEmail do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Persons.Person

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Sign Up for a #{gettext("Time Slot")}")
    |> assign(:signup, nil)
    |> assign(:changeset, Persons.change_person(%Person{}))
  end

  defp apply_action(socket, :code, %{"id" => id}) do
    with {:get_person, person} when not is_nil(person) <- {:get_person, Persons.get_person(id)} do
      socket
      |> assign(:page_title, "Confirm Email Address")
      |> assign(:person, person)
    else
      {:get_person, nil} ->
        socket
        |> put_flash(:error, "Something went wrong, please try again.")
        |> push_redirect(to: Routes.public_signup_confirm_email_path(socket, :index))
    end
  end

  # no id received = error condition
  defp apply_action(socket, :code, _params) do
    socket
    |> push_redirect(to: Routes.public_signup_confirm_email_path(socket, :index))
    |> put_flash(:error, "Something went wrong, please try again.")
  end

  @impl true
  def handle_event("confirm_email", %{"person" => %{"email" => email}}, socket) do
    case Persons.get_or_create_person_for_confirm_email(email, socket.assigns.site_id) do
      {:ok, person} ->
        CrewWeb.PersonEmail.confirm_email(person)
        |> Crew.Mailer.deliver_now()

        {:noreply,
         socket
         |> put_flash(
           :info,
           "An confirmation email containing a link and a code has been sent to you. To continue, please either follow the link or enter the code here."
         )
         |> push_redirect(to: Routes.public_signup_confirm_email_path(socket, :code, person.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
