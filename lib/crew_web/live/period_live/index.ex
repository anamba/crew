defmodule CrewWeb.PeriodLive.Index do
  use CrewWeb, :live_view

  alias Crew.Periods
  alias Crew.Periods.Period

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :periods, list_periods())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Period")
    |> assign(:period, Periods.get_period!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Period")
    |> assign(:period, %Period{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Periods")
    |> assign(:period, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    period = Periods.get_period!(id)
    {:ok, _} = Periods.delete_period(period)

    {:noreply, assign(socket, :periods, list_periods())}
  end

  defp list_periods do
    Periods.list_periods()
  end
end
