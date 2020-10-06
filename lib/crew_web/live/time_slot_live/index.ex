defmodule CrewWeb.TimeSlotLive.Index do
  use CrewWeb, :live_view

  alias Crew.Activities

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)

    {:ok,
     assign_new(socket, :time_slot_batches, fn -> Activities.list_time_slots_by_batch(site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit #{gettext("Time Slots")}")
    |> assign(:time_slot, Activities.get_time_slot!(id))
  end

  defp apply_action(socket, :new, _params) do
    site = Crew.Sites.get_site!(socket.assigns.site_id)

    socket
    |> assign(:page_title, "New #{gettext("Time Slot")}")
    |> assign(:time_slot, Activities.new_time_slot(site))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Time Slots"))
    |> assign(:time_slot, nil)
  end
end
