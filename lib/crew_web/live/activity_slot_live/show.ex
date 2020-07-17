defmodule CrewWeb.ActivitySlotLive.Show do
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
     |> assign(:activity_slot, Activities.get_activity_slot!(id))}
  end

  defp page_title(:show), do: "Show Activity slot"
  defp page_title(:edit), do: "Edit Activity slot"
end
