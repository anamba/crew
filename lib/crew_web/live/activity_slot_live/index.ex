defmodule CrewWeb.ActivitySlotLive.Index do
  use CrewWeb, :live_view

  alias Crew.Activities
  alias Crew.Activities.ActivitySlot

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :activity_slots, list_activity_slots(socket.session["site_id"]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity slot")
    |> assign(:activity_slot, Activities.get_activity_slot!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity slot")
    |> assign(:activity_slot, %ActivitySlot{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activity slots")
    |> assign(:activity_slot, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity_slot = Activities.get_activity_slot!(id)
    {:ok, _} = Activities.delete_activity_slot(activity_slot)

    {:noreply, assign(socket, :activity_slots, list_activity_slots(socket.session["site_id"]))}
  end

  defp list_activity_slots(site_id) do
    Activities.list_activity_slots(site_id)
  end
end
