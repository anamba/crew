defmodule CrewWeb.ActivityTagLive.Show do
  use CrewWeb, :live_view

  alias Crew.Activities

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    {:ok, assign(socket, :site_id, site_id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity_tag, Activities.get_activity_tag!(id))}
  end

  defp page_title(:show), do: "Show Activity tag"
  defp page_title(:edit), do: "Edit Activity tag"
end
