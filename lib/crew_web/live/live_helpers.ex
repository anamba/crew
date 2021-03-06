defmodule CrewWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML.Link

  alias CrewWeb.Router.Helpers, as: Routes

  @doc """
  Renders a component inside the `CrewWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, CrewWeb.OrganizationLive.FormComponent,
        id: @organization.id || :new,
        action: @live_action,
        organization: @organization,
        return_to: Routes.organization_index_path(@socket, :index) %>
  """
  def live_modal(_socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(_socket, CrewWeb.ModalComponent, modal_opts)
  end

  def assign_from_session_with_person(socket, %{"person_id" => person_id} = params) do
    socket =
      socket
      |> assign_from_session(params)
      |> assign_new(:current_person, fn -> Crew.Persons.get_person(person_id) end)

    if socket.assigns.current_person && socket.assigns.current_person.email_confirmed_at,
      do: socket,
      else: redirect(socket, to: Routes.public_signup_index_path(socket, :index))
  end

  def assign_from_session_with_person(socket, params) do
    socket
    |> assign_from_session(params)
    |> redirect(to: Routes.public_signup_index_path(socket, :index))
  end

  def assign_from_session(socket, %{"site_id" => site_id}) do
    socket =
      socket
      |> assign(:site_id, site_id)
      |> assign_new(:current_site, fn -> Crew.Sites.get_site!(site_id) end)

    socket
    |> assign(:time_zone, socket.assigns.current_site.default_time_zone)
  end

  def assign_from_session(socket, _params) do
    socket
  end

  def time_range_to_str(start_time, end_time) do
    start_time_format =
      if Timex.format!(start_time, "%p", :strftime) ==
           Timex.format!(end_time, "%p", :strftime),
         do: "%a %Y-%m-%d %-I:%M",
         else: "%a %Y-%m-%d %-I:%M%P"

    end_time_format =
      if NaiveDateTime.to_date(start_time) == NaiveDateTime.to_date(end_time),
        do: "%-I:%M%P",
        else: "%a %Y-%m-%d %-I:%M%P"

    Timex.format!(start_time, start_time_format, :strftime) <>
      " – " <>
      Timex.format!(end_time, end_time_format, :strftime)
  end

  def format_timestamp(timestamp, time_zone) do
    Timex.Timezone.convert(timestamp, time_zone)
    |> Timex.format!("%Y-%m-%d %I:%M%P", :strftime)
  end

  def last_page(count, per_page) do
    ceil(count / per_page)
  end

  def paginator(page, per_page, count) do
    assigns = []

    ~L"""
      <%= if count > 0 do %>
      <div class="my-4 text-center">
        <%= if last_page(count, per_page) > 1 do %>
          <div class="mb-2">
            <div class="inline-block px-2 py-1 rounded-lg">
            <%= if page > 1 do %>
              <%= link "‹ Prev", to: "#", phx_click: "set_page", phx_value_page: page - 1 %>
            <% else %>
              ‹ Prev
            <% end %>
            </div>
            <%= for pg <- 1..last_page(count, per_page) do %>
              <div class="inline-block px-2 py-1 <%= if page == pg, do: "bg-gray-100" %> rounded-lg">
                <%= if page == pg, do: pg, else: link pg, to: "#", phx_click: "set_page", phx_value_page: pg %>
              </div>
            <% end %>
            <div class="inline-block px-2 py-1 rounded-lg">
            <%= if page < last_page(count, per_page) do %>
              <%= link "Next ›", to: "#", phx_click: "set_page", phx_value_page: page + 1 %>
            <% else %>
              Next ›
            <% end %>
            </div>
          </div>
        <% end %>
        <div class="text-sm">
          Displaying <%= (page - 1) * per_page + 1 %>-<%= [page * per_page, count] |> Enum.min %> out of <%= count %>
        </div>
      </div>
      <% end %>
    """
  end
end
