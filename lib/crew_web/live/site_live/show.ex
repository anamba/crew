defmodule CrewWeb.SiteLive.Show do
  use CrewWeb, :live_view

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

  defp page_title(:show), do: "Show Site"
  defp page_title(:edit), do: "Edit Site"
end
