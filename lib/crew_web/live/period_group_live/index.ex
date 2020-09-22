defmodule CrewWeb.PeriodGroupLive.Index do
  use CrewWeb, :live_view

  alias Crew.Periods
  alias Crew.Periods.PeriodGroup

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
    {:ok, assign_new(socket, :period_groups, fn -> list_period_groups(site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    period_group = Periods.get_period_group!(id)

    socket
    |> assign(:page_title, "Editing: #{period_group.name}")
    |> assign(:period_group, period_group)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New #{gettext("Period Group")}")
    |> assign(:period_group, %PeriodGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Period Groups"))
    |> assign(:period_group, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    period_group = Periods.get_period_group!(id)
    {:ok, _} = Periods.delete_period_group(period_group)

    {:noreply, assign(socket, :period_groups, list_period_groups(socket.assigns.site_id))}
  end

  defp list_period_groups(site_id) do
    Periods.list_period_groups(site_id)
  end
end
