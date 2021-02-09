defmodule CrewWeb.SignupController do
  use CrewWeb, :controller

  alias Crew.{Persons, Persons.Person}

  # GET
  def verify_code(conn, %{"id" => id, "code" => code}) do
    verify_code(conn, id, code)
  end

  # POST
  def verify_code(conn, %{"code" => %{"id" => id, "code" => code}}) do
    verify_code(conn, id, code)
  end

  def verify_code(conn, _params) do
    conn = put_flash(conn, :error, "Something went wrong (missing required params)")
    redirect(conn, to: Routes.public_signup_index_path(conn, :index))
  end

  defp verify_code(conn, id, code) do
    with {:get_person, person} when not is_nil(person) <- {:get_person, Persons.get_person(id)},
         {:otp_valid, person, true} <-
           {:otp_valid, person, Person.verify_totp_code(person, code)},
         {:confirmed, person, {:ok, _}} <- {:confirmed, person, Persons.confirm_email(person)} do
      conn = put_session(conn, :person_id, person.id)

      if Person.profile_complete?(person) do
        redirect(conn, to: Routes.public_time_slots_index_path(conn, :index))
      else
        redirect(conn, to: Routes.public_signup_index_path(conn, :profile))
      end
    else
      {:get_person, nil} ->
        conn
        |> put_flash(:error, "Something went wrong, please try again.")
        |> redirect(to: Routes.public_signup_confirm_email_path(conn, :index))

      {:otp_valid, person, false} ->
        conn
        |> assign(:page_title, "Confirm Email Address")
        |> put_flash(:error, "The code you entered was not valid, please try again.")
        |> redirect(to: Routes.public_signup_confirm_email_path(conn, :code, id: person.id))

      {:confirmed, person, {:error, _changeset}} ->
        conn
        |> assign(:page_title, "Confirm Email Address")
        |> put_flash(:error, "Sorry, an error occurred. Please try again later.")
        |> redirect(to: Routes.public_signup_confirm_email_path(conn, :code, id: person.id))
    end
  end

  def log_out(conn, _params) do
    conn
    |> put_session(:person_id, nil)
    |> redirect(to: Routes.public_signup_index_path(conn, :index))
  end
end
