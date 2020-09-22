defmodule CrewWeb.LocationLive.Index do
  use CrewWeb, :live_view

  alias Crew.Locations
  alias Crew.Locations.Location

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
    {:ok, assign_new(socket, :locations, fn -> list_locations(site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Location")
    |> assign(:location, Locations.get_location!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Location")
    |> assign(:location, %Location{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Locations")
    |> assign(:location, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    location = Locations.get_location!(id)
    {:ok, _} = Locations.delete_location(location)

    {:noreply, assign(socket, :locations, list_locations(socket.assigns.site_id))}
  end

  defp list_locations(site_id) do
    Locations.list_locations(site_id)
  end
end
