defmodule CrewWeb.PersonLive.RelFormComponent do
  use CrewWeb, :live_component

  alias Crew.Persons
  alias Crew.Persons.PersonRel

  @impl true
  def update(%{person: person} = assigns, socket) do
    changeset = Persons.change_person_rel(%PersonRel{}, %{src_person_id: person.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:person_rel, %PersonRel{dest_person: nil})
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"person_rel" => person_rel_params, "person_query" => person_query},
        socket
      ) do
    site_id = socket.assigns.site_id

    changeset =
      %PersonRel{}
      |> Persons.change_person_rel(person_rel_params)
      |> Map.put(:action, :validate)

    socket =
      case person_query do
        "" ->
          socket

        query ->
          assign(
            socket,
            :person_search_results,
            Persons.search(query, site_id)
            |> Enum.filter(&(&1.id != socket.assigns.person.id))
          )
      end
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  def handle_event("set_dest_person_id", %{"id" => id}, socket) do
    case Persons.get_person(id) do
      nil ->
        {:noreply, socket}

      person ->
        person_rel = Map.put(socket.assigns.person_rel, :dest_person, person)
        {:noreply, assign(socket, person_rel: person_rel, person_search_results: nil)}
    end
  end

  @impl true
  def handle_event("save", %{"person_rel" => person_rel_params}, socket) do
    case Persons.create_person_rel(person_rel_params) do
      {:ok, _person_rel} ->
        {:noreply,
         socket
         |> put_flash(:info, "Relationship created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
