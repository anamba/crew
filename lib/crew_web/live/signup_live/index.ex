defmodule CrewWeb.SignupLive.Index do
  use CrewWeb, :live_view

  alias Crew.Signups
  alias Crew.Signups.Signup

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
    {:ok, assign_new(socket, :signups, fn -> list_signups(site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Signup")
    |> assign(:signup, Signups.get_signup!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Signup")
    |> assign(:signup, %Signup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Signups")
    |> assign(:signup, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    signup = Signups.get_signup!(id)
    {:ok, _} = Signups.delete_signup(signup)

    {:noreply, assign(socket, :signups, list_signups(socket.assigns[:site_id]))}
  end

  defp list_signups(site_id) do
    Signups.list_signups(site_id)
  end
end
