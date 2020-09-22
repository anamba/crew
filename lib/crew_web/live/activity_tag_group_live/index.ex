defmodule CrewWeb.ActivityTagGroupLive.Index do
  use CrewWeb, :live_view

  alias Crew.Activities
  alias Crew.Activities.ActivityTagGroup

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
    {:ok, assign_new(socket, :activity_tag_groups, fn -> list_activity_tag_groups(site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity tag group")
    |> assign(:activity_tag_group, Activities.get_activity_tag_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity tag group")
    |> assign(:activity_tag_group, %ActivityTagGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activity tag groups")
    |> assign(:activity_tag_group, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity_tag_group = Activities.get_activity_tag_group!(id)
    {:ok, _} = Activities.delete_activity_tag_group(activity_tag_group)

    {:noreply,
     assign(socket, :activity_tag_groups, list_activity_tag_groups(socket.assigns.site_id))}
  end

  defp list_activity_tag_groups(site_id) do
    Activities.list_activity_tag_groups(site_id)
  end
end
