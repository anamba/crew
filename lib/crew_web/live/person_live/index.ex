defmodule CrewWeb.PersonLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Persons.Person

  @person_preload [taggings: [:tag], in_rels: [:src_person], out_rels: [:dest_person]]
  @per_page_default 25

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign_new(:page, fn -> 1 end)
      |> assign_new(:per_page, fn -> @per_page_default end)
      |> assign_new(:persons, fn -> [] end)
      |> assign_new(:q, fn -> "" end)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("search", %{"q" => q}, socket) do
    socket = assign(socket, :page, 1)
    params = if (q || "") == "", do: %{}, else: %{"q" => q}
    {:noreply, push_patch(socket, to: Routes.person_index_path(socket, :index, params))}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    person = Persons.get_person!(id)

    socket
    |> assign(:page_title, "Editing: #{person.name}")
    |> assign(:person, person)
    |> assign_new(:persons, fn -> [] end)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New #{gettext("Person")}")
    |> assign(:person, %Person{})
    |> assign_new(:persons, fn -> [] end)
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, gettext("Persons"))
    |> assign(:persons, list_persons(params["q"], socket))
    |> assign(:q, params["q"])
  end

  defp list_persons(nil, socket), do: list_persons("", socket)

  defp list_persons("", socket) do
    Persons.list_recent_persons(
      @person_preload,
      socket.assigns[:page] || 1,
      socket.assigns[:per_page] || @per_page_default,
      socket.assigns.site_id
    )
  end

  defp list_persons(query, socket) do
    Persons.search(
      query,
      @person_preload,
      socket.assigns[:page] || 1,
      socket.assigns[:per_page] || @per_page_default,
      socket.assigns.site_id
    )
  end
end
