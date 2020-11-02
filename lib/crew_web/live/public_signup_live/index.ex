defmodule CrewWeb.PublicSignupLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons

  @impl true
  def mount(_params, session, socket) do
    # may or may not be present depending on where we are in the process
    socket = assign(socket, :person_id, session["person_id"])
    {:ok, assign_from_session(socket, session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("validate_profile", %{"person" => person_params}, socket) do
    person = socket.assigns.current_person

    {:noreply,
     socket
     |> assign(:changeset, Persons.change_person_profile(person, person_params))
     |> Map.put(:action, :validate)}
  end

  @impl true
  def handle_event("save_profile", %{"person" => person_params}, socket) do
    person = socket.assigns.current_person

    case Persons.update_person_profile(person, person_params) do
      {:ok, person} ->
        {:noreply, redirect(socket, to: Routes.public_time_slots_index_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Sign Up for a #{gettext("Time Slot")}")
  end

  defp apply_action(socket, :profile, _params) do
    person = Persons.get_person(socket.assigns.person_id)

    if person && person.email_confirmed_at do
      socket
      |> assign(:page_title, "Complete Your Profile")
      |> assign(:current_person, person)
      |> assign(:changeset, Persons.change_person_profile(person))
    else
      redirect(socket, to: Routes.public_signup_index_path(socket, :index))
    end
  end
end
