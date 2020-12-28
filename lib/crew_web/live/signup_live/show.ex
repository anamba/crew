defmodule CrewWeb.SignupLive.Show do
  use CrewWeb, :live_view

  alias Crew.Signups
  alias Crew.TimeSlots

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_from_session(socket, session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    signup = Signups.get_signup!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, signup))
     |> assign(:signup, signup)
     |> assign(:time_slots, TimeSlots.list_time_slots(socket.assigns.site_id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    signup = Signups.get_signup!(id)
    {:ok, _} = Signups.delete_signup(signup)

    {:noreply, redirect(socket, to: Routes.signup_index_path(socket, :index))}
  end

  defp page_title(:show, signup), do: "Show #{gettext("Signup")} for #{signup.guest.name}"
  defp page_title(:edit, signup), do: "Editing #{gettext("Signup")} for #{signup.guest.name}"
end
