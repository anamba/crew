defmodule CrewWeb.PersonLive.Show do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Signups

  @person_preload [taggings: [:tag], in_rels: [:src_person], out_rels: [:dest_person]]

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    {:ok, assign(socket, :site_id, site_id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    person = Persons.get_person(id) |> Crew.Repo.preload(@person_preload)

    if person do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action, person))
       |> assign(:person, person)
       |> assign(:signups, Signups.list_signups_for_guest(person.id, true))}
    else
      {:noreply, push_redirect(socket, to: Routes.person_index_path(socket, :index))}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Persons.get_person!(id)
    {:ok, _} = Persons.delete_person(person)

    {:noreply, push_redirect(socket, to: Routes.person_index_path(socket, :index))}
  end

  @impl true
  def handle_event("cancel_signup", %{"id" => id}, socket) do
    signup = Signups.get_signup!(id)
    {:ok, _} = Signups.delete_signup(signup)

    {:noreply,
     assign(socket, :signups, Signups.list_signups_for_guest(socket.assigns.person.id, true))}
  end

  @impl true
  def handle_event("remove_rel", %{"id" => id}, socket) do
    person_rel = Persons.get_person_rel!(id)
    {:ok, _} = Persons.delete_person_rel(person_rel)

    person = Persons.get_person!(socket.assigns.person.id) |> Crew.Repo.preload(@person_preload)
    {:noreply, assign(socket, :person, person)}
  end

  defp page_title(:edit, person), do: "Editing: #{person.name}"
  defp page_title(_, person), do: person.name
end
