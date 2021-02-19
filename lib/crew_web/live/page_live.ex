defmodule CrewWeb.PageLive do
  use CrewWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session(socket, session)

    page_title =
      case socket.assigns.live_action do
        :index -> "Crew: Simplifying Scheduling"
      end

    {:ok, assign(socket, :page_title, page_title)}
  end
end
