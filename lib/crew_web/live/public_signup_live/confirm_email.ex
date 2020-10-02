defmodule CrewWeb.PublicSignupLive.ConfirmEmail do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Persons.Person

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
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

  # received id and code (magic link)
  defp apply_action(socket, :code, %{"id" => id, "otp" => otp}) do
    with {:get_person, person} when not is_nil(person) <- {:get_person, Persons.get_person(id)},
         {:otp_valid, person, true} <- {:otp_valid, person, Person.verify_totp_code(person, otp)} do
      socket
      |> assign(:person, person)
      |> push_redirect(to: Routes.public_signup_index_path(socket, :profile))
    else
      {:get_person, nil} ->
        socket
        |> put_flash(:error, "Something went wrong, please try again.")
        |> push_redirect(to: Routes.public_signup_confirm_email_path(socket, :index))

      {:otp_valid, person, false} ->
        socket
        |> assign(:person, person)
        |> assign(:page_title, "Confirm Email Address")
        |> put_flash(:error, "The code you entered was not valid, please try again.")
    end
  end

  # received code only, but person in socket (web form)
  defp apply_action(%{assigns: %{person: person}} = socket, :code, %{"otp" => otp}) do
    with {:otp_valid, true} <- {:otp_valid, Person.verify_totp_code(person, otp)} do
      socket
      |> push_redirect(to: Routes.public_signup_index_path(socket, :profile))
    else
      {:otp_valid, false} ->
        socket
        |> assign(:page_title, "Confirm Email Address")
        |> put_flash(:error, "The code you entered was not valid, please try again.")
    end
  end

  # no id or code received, but person in socket, prompt for code
  defp apply_action(%{assigns: %{person: %Person{}}} = socket, :code, _params) do
    socket
    |> assign(:page_title, "Confirm Email Address")
  end

  # no id/code received, no person in socket... error condition
  defp apply_action(socket, :code, _params) do
    socket
    |> push_redirect(to: Routes.public_signup_confirm_email_path(socket, :index))
    |> put_flash(:error, "Something went wrong, please try again.")
  end

  @impl true
  def handle_event("confirm_email", %{"person" => %{"email" => email}}, socket) do
    case Persons.create_person_for_confirm_email(email, socket.assigns.site_id) do
      {:ok, person} ->
        # TODO: actually send confirmation email
        {:noreply,
         socket
         |> put
         #  |> put_flash(
         #    :info,
         #    "Confirmation email sent. Please use the link in the email to continue, or enter the code here."
         #  )
         |> put_flash(
           :info,
           "[TEMPORARY] Email not implemented yet, enter this code: #{
             Person.generate_totp_code(person)
           }"
         )
         |> push_redirect(to: Routes.public_signup_confirm_email_path(socket, :code))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
