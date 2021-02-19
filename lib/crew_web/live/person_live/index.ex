defmodule CrewWeb.PersonLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Persons.Person

  @person_preload [taggings: [:tag], in_rels: [:src_person], out_rels: [:dest_person]]
  @per_page_default 25

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_from_session(socket, session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign_new(:page, fn -> 1 end)
      |> assign_new(:per_page, fn -> @per_page_default end)
      |> assign_new(:persons, fn -> [] end)
      |> assign_new(:person_tags, fn -> [] end)

    socket =
      assign(
        socket,
        :active_person_tags,
        params
        |> Enum.map(fn
          {"pt_" <> id, _} -> Persons.get_person_tag(id)
          {_, _} -> nil
        end)
        |> Enum.filter(& &1)
      )

    tag_params = Enum.map(socket.assigns.active_person_tags, &{"pt_#{&1.id}", "1"})

    socket = assign(socket, :search_params, Map.new([{"q", params["q"]} | tag_params]))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("search", %{"q" => q}, socket) do
    params = %{"q" => String.trim(q || "")}
    search_params = Map.merge(socket.assigns.search_params, params)

    socket =
      socket
      |> assign(:page, 1)
      |> assign(:search_params, search_params)

    {:noreply, push_patch(socket, to: Routes.person_index_path(socket, :index, search_params))}
  end

  def handle_event("add_filter", %{"person-tag-id" => person_tag_id}, socket) do
    search_params = Map.put(socket.assigns.search_params, "pt_#{person_tag_id}", "1")

    socket =
      socket
      |> assign(:page, 1)
      |> assign(:search_params, search_params)

    {:noreply, push_patch(socket, to: Routes.person_index_path(socket, :index, search_params))}
  end

  def handle_event("remove_filter", %{"person-tag-id" => person_tag_id}, socket) do
    search_params = Map.delete(socket.assigns.search_params, "pt_#{person_tag_id}")

    socket =
      socket
      |> assign(:page, 1)
      |> assign(:search_params, search_params)

    {:noreply, push_patch(socket, to: Routes.person_index_path(socket, :index, search_params))}
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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Persons"))
    |> assign(:persons, list_persons(socket.assigns.search_params["q"], socket))
    |> assign(:person_tags, Persons.list_person_tags(socket.assigns.site_id))
    |> assign(:q, socket.assigns.search_params["q"])
  end

  defp list_persons(nil, socket), do: list_persons("", socket)

  defp list_persons("", socket) do
    Persons.list_recent_persons(
      socket.assigns.active_person_tags,
      @person_preload,
      socket.assigns[:page] || 1,
      socket.assigns[:per_page] || @per_page_default,
      socket.assigns.site_id
    )
  end

  defp list_persons(query, socket) do
    Persons.search(
      query,
      socket.assigns.active_person_tags,
      @person_preload,
      socket.assigns[:page] || 1,
      socket.assigns[:per_page] || @per_page_default,
      socket.assigns.site_id
    )
  end
end
