defmodule CrewWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

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
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, CrewWeb.ModalComponent, modal_opts)
  end

  def assign_from_session_with_person(socket, %{"person_id" => person_id} = params) do
    socket =
      socket
      |> assign_from_session(params)
      |> assign_new(:current_person, fn -> Crew.Persons.get_person!(person_id) end)

    if socket.assigns.current_person && socket.assigns.current_person.email_confirmed_at,
      do: socket,
      else: redirect(socket, to: Routes.public_signup_index_path(socket, :index))
  end

  def assign_from_session_with_person(socket, params) do
    socket
    |> assign_from_session(params)
    |> redirect(to: Routes.public_signup_index_path(socket, :index))
  end

  def assign_from_session(socket, %{"site_id" => site_id} = params) do
    assign(socket, :site_id, site_id)
  end

  def assign_from_session(socket, _params) do
    socket
  end
end
