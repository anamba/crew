defmodule CrewWeb.SignupLive.Index do
  use CrewWeb, :live_view

  alias Crew.Signups
  alias Crew.TimeSlots

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_from_session(session)
      |> refresh_counts()

    TimeSlots.subscribe(socket.assigns.site_id)

    socket =
      if socket.assigns[:signups] do
        socket
      else
        set_page(socket)
      end

    {:ok, assign_new(socket, :signups, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("set_page", %{"page" => page}, socket) do
    {:noreply, set_page(assign(socket, :page, String.to_integer(page)))}
  end

  @impl true
  def handle_info({TimeSlots, "time_slot-changed", _time_slot}, socket) do
    {:noreply, refresh_counts(socket)}
  end

  def set_page(socket) do
    assign(socket, Signups.list_signups(socket.assigns[:page] || 1, socket.assigns.site_id))
  end

  def refresh_counts(socket) do
    site_id = socket.assigns.site_id

    socket
    |> assign(
      :total_future_available_signup_count,
      TimeSlots.total_future_available_signup_count(site_id)
    )
    |> assign(:total_future_guest_count, TimeSlots.total_future_guest_count(site_id))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    signup = Signups.get_signup!(id)

    socket
    |> assign(:page_title, "Edit #{gettext("Signup")}")
    |> assign(:signup, signup)
    |> assign(:time_slots, TimeSlots.list_time_slots(socket.assigns.site_id))
  end

  defp apply_action(socket, :new, _params) do
    site = Crew.Sites.get_site!(socket.assigns.site_id)

    socket
    |> assign(:page_title, "New #{gettext("Signup")}")
    |> assign(:signup, Signups.new_signup(site))
    |> assign(:time_slots, TimeSlots.list_time_slots(socket.assigns.site_id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Signups"))
    |> assign(:signup, nil)
  end
end
