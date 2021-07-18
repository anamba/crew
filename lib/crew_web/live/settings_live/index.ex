defmodule CrewWeb.SettingsLive.Index do
  use CrewWeb, :live_view

  alias Crew.Sites

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session(socket, session)

    site = Sites.get_site!(socket.assigns.site_id)
    changeset = Sites.change_site(site)

    {:ok, assign(socket, site: site, changeset: changeset)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Settings")
  end

  @impl true
  def handle_event("validate", %{"site" => site_params}, socket) do
    changeset =
      socket.assigns.site
      |> Sites.change_site(site_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"site" => site_params}, socket) do
    case Sites.update_site(socket.assigns.site, site_params) do
      {:ok, _site} ->
        {:noreply,
         socket
         |> put_flash(:info, "Settings updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
