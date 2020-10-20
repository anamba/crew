defmodule CrewWeb.PersonLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Persons.Person

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session(socket, session)
    {:ok, assign_new(socket, :persons, fn -> list_persons(socket.assigns.site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign_new(:page, fn -> 1 end)
      |> assign_new(:limit, fn -> 25 end)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

  defp list_persons(page \\ 1, limit \\ 100, site_id) do
    Persons.list_persons(
      page,
      limit,
      [taggings: [:tag], in_rels: [:src_person], out_rels: [:dest_person]],
      site_id
    )
  end
end
