defmodule CrewWeb.PersonLive.Index do
  use CrewWeb, :live_view

  alias Crew.Persons
  alias Crew.Persons.Person

  @impl true
  def mount(_params, %{"site_id" => site_id}, socket) do
    socket = assign(socket, :site_id, site_id)
    {:ok, assign_new(socket, :persons, fn -> list_persons(site_id) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Persons.get_person!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Persons")
    |> assign(:person, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Persons.get_person!(id)
    {:ok, _} = Persons.delete_person(person)

    {:noreply, assign(socket, :persons, list_persons(socket.assigns.site_id))}
  end

  defp list_persons(site_id) do
    Persons.list_persons(site_id)
  end
end
