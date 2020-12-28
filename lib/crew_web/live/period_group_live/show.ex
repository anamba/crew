defmodule CrewWeb.PeriodGroupLive.Show do
  use CrewWeb, :live_view

  alias Crew.Periods

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    {:ok, assign(socket, :site_id, site_id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    period_group = Periods.get_period_group!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(period_group, socket.assigns.live_action))
     |> assign(:period_group, period_group)}
  end

  defp page_title(period_group, :show), do: "#{period_group.name}"
  defp page_title(period_group, :edit), do: "Editing: #{period_group.name}"
end
