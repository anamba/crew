defmodule CrewWeb.ActivityLive.Show do
  use CrewWeb, :live_view

  alias Crew.Activities

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    {:ok, assign(socket, :site_id, site_id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    activity = Activities.get_activity!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, activity))
     |> assign(:activity, activity)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activities.get_activity!(id)
    {:ok, _} = Activities.delete_activity(activity)

    {:noreply, socket |> push_redirect(to: Routes.activity_index_path(socket, :index))}
  end

  defp page_title(:show, activity), do: activity.name
  defp page_title(:edit, activity), do: "Editing: #{activity.name}"
end
