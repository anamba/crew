defmodule CrewWeb.ActivityTagLive.Index do
  use CrewWeb, :live_view

  alias Crew.Activities
  alias Crew.Activities.ActivityTag

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :activity_tags, list_activity_tags())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity tag")
    |> assign(:activity_tag, Activities.get_activity_tag!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity tag")
    |> assign(:activity_tag, %ActivityTag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activity tags")
    |> assign(:activity_tag, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity_tag = Activities.get_activity_tag!(id)
    {:ok, _} = Activities.delete_activity_tag(activity_tag)

    {:noreply, assign(socket, :activity_tags, list_activity_tags())}
  end

  defp list_activity_tags do
    Activities.list_activity_tags()
  end
end
