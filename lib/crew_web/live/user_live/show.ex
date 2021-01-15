defmodule CrewWeb.UserLive.Show do
  use CrewWeb, :live_view

  alias Crew.Accounts

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_from_session(socket, session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, Accounts.get_user!(id))}
  end

  @impl true
  def handle_event("destroy", _, socket) do
    {:ok, user} = Accounts.delete_user(socket.assigns.user)
    socket = put_flash(socket, :info, "User #{user.name} deleted successfully.")

    {:noreply, live_redirect(socket, to: Routes.user_index_path(socket, :index))}
  end

  @impl true
  def handle_event("reset_password", _, socket) do
    site = Crew.Sites.get_site_by(socket.assigns.site_id)
    uri = %URI{scheme: "https", host: site.primary_domain}

    Accounts.deliver_user_reset_password_instructions(
      socket.assigns.user,
      &Routes.user_reset_password_url(uri, :edit, &1)
    )

    socket =
      put_flash(socket, :info, "Reset password email sent to #{socket.assigns.user.email}.")

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
