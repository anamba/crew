defmodule CrewWeb.PeriodGroupLive.Index do
  use CrewWeb, :live_view

  alias Crew.Periods
  alias Crew.Periods.PeriodGroup

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :period_groups, list_period_groups())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Period group")
    |> assign(:period_group, Periods.get_period_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Period group")
    |> assign(:period_group, %PeriodGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Period groups")
    |> assign(:period_group, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    period_group = Periods.get_period_group!(id)
    {:ok, _} = Periods.delete_period_group(period_group)

    {:noreply, assign(socket, :period_groups, list_period_groups())}
  end

  defp list_period_groups do
    Periods.list_period_groups()
  end
end
