defmodule CrewWeb.PersonLive.Show do
  use CrewWeb, :live_view

  alias Crew.Persons

  @person_preload [taggings: [:tag], in_rels: [:src_person], out_rels: [:dest_person]]

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    {:ok, assign(socket, :site_id, site_id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    person = Persons.get_person!(id) |> Crew.Repo.preload(@person_preload)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, person))
     |> assign(:person, person)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Persons.get_person!(id)
    {:ok, _} = Persons.delete_person(person)

    {:noreply, push_redirect(socket, to: Routes.person_index_path(socket, :index))}
  end

  defp page_title(:edit, person), do: "Editing: #{person.name}"
  defp page_title(_, person), do: person.name
end
