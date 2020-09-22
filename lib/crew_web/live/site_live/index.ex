defmodule CrewWeb.SiteLive.Index do
  use CrewWeb, :live_view

  alias Crew.Sites
  alias Crew.Sites.Site

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
    {:ok, assign_new(socket, :sites, fn -> list_sites() end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site")
    |> assign(:site, Sites.get_site!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site")
    |> assign(:site, %Site{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sites")
    |> assign(:site, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = Sites.get_site!(id)
    {:ok, _} = Sites.delete_site(site)

    {:noreply, assign(socket, :sites, list_sites())}
  end

  defp list_sites do
    Sites.list_sites()
  end
end
