defmodule CrewWeb.ActivityTagGroupLive.Show do
  use CrewWeb, :live_view

  alias Crew.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity_tag_group, Activities.get_activity_tag_group!(id))}
  end

  defp page_title(:show), do: "Show Activity tag group"
  defp page_title(:edit), do: "Edit Activity tag group"
end
