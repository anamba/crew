defmodule CrewWeb.SiteLive.Show do
  use CrewWeb, :live_view

  alias Crew.Signups
  alias Crew.Sites

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, :site_id, session[:site_id])}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:site, Sites.get_site!(id))}
  end

  @impl true
  def handle_event("send_signup_reminders", _, socket) do
    site = socket.assigns.site

    signups_by_guest =
      Signups.list_upcoming_signups(site.id)
      |> Enum.group_by(& &1.guest)

    signups_by_guest
    |> Enum.map(fn {guest, signups} ->
      Enum.each(signups, &Signups.set_reminded_at/1)
      if guest, do: CrewWeb.PersonEmail.reminder(guest, signups)
    end)
    |> Enum.filter(& &1)
    |> Enum.each(&Crew.Mailer.deliver_later/1)

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Site"
  defp page_title(:edit), do: "Edit Site"
end
