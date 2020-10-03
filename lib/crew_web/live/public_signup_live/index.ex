defmodule CrewWeb.PublicSignupLive.Index do
  use CrewWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_from_session(socket, session)}
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
    |> assign(:page_title, "Complete Your Profile")
  end
end
