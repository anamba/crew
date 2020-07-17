defmodule CrewWeb.PeriodGroupLive.Show do
  use CrewWeb, :live_view

  alias Crew.Periods

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:period_group, Periods.get_period_group!(id))}
  end

  defp page_title(:show), do: "Show Period group"
  defp page_title(:edit), do: "Edit Period group"
end
