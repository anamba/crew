defmodule CrewWeb.PublicSignupLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Persons.Person

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Sign Up for a #{gettext("Time Slot")}")
  end

  defp apply_action(socket, :profile, _params) do
    socket
    |> assign(:page_title, "Edit Profile")
  end
end
