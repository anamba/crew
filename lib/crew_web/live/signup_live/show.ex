defmodule CrewWeb.SignupLive.Show do
  use CrewWeb, :live_view

  alias Crew.Signups

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:signup, Signups.get_signup!(id))}
  end

  defp page_title(:show), do: "Show Signup"
  defp page_title(:edit), do: "Edit Signup"
end
