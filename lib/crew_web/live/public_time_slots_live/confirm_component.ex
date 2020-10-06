defmodule CrewWeb.PublicTimeSlotsLive.ConfirmComponent do
  use CrewWeb, :live_component

  alias Crew.Signups

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:signups, Signups.list_signups_for_guest(assigns.current_person.id, true))}
  end

  @impl true
  def handle_event("cancel", %{"id" => signup_id}, socket) do
    signup = Signups.get_signup!(signup_id)
    Signups.delete_signup(signup)

    {:noreply,
     assign(
       socket,
       :signups,
       Signups.list_signups_for_guest(socket.assigns.current_person.id, true)
     )}
  end
end
