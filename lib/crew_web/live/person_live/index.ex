defmodule CrewWeb.PersonLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Persons.Person

  @person_preload [taggings: [:tag], in_rels: [:src_person], out_rels: [:dest_person]]
  @per_page_default 25

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session(socket, session)
    {:ok, assign_new(socket, :persons, fn -> list_persons(socket) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign_new(:page, fn -> 1 end)
      |> assign_new(:per_page, fn -> @per_page_default end)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("search", %{"q" => q}, socket) do
    socket =
      socket
      |> assign(:page, 1)
      |> assign(:persons, Persons.search(q, @person_preload, socket.assigns.site_id))

    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    person = Persons.get_person!(id)

    socket
    |> assign(:page_title, "Editing: #{person.name}")
    |> assign(:person, person)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New #{gettext("Person")}")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Persons"))
    |> assign(:person, nil)
  end

  defp list_persons(query \\ "", socket) do
    Persons.search(
      query,
      @person_preload,
      socket.assigns[:page] || 1,
      socket.assigns[:per_page] || @per_page_default,
      socket.assigns.site_id
    )
  end
end
