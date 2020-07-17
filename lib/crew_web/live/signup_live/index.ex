defmodule CrewWeb.SignupLive.Index do
  use CrewWeb, :live_view

  alias Crew.Signups
  alias Crew.Signups.Signup

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :signups, list_signups())}
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

    {:noreply, assign(socket, :signups, list_signups())}
  end

  defp list_signups do
    Signups.list_signups()
  end
end
