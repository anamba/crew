defmodule CrewWeb.PersonLive.TagFormComponent do
  use CrewWeb, :live_component

  alias Crew.Persons
  alias Crew.Persons.PersonTagging

  @impl true
  def update(assigns, socket) do
    changeset = Persons.change_person_tagging(%PersonTagging{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:person_tags, fn -> Crew.Persons.list_person_tags(assigns.site_id) end)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"person_tagging" => person_tagging_params}, socket) do
    socket =
      with id <- person_tagging_params["person_tag_id"],
           tag when not is_nil(tag) <- Persons.get_person_tag(id) do
        socket = assign(socket, :person_tag, tag)

        case tag.value_choices_json && Jason.decode(tag.value_choices_json) do
          {:ok, choices} -> assign(socket, :person_tag_value_choices, choices)
          _ -> socket
        end
      else
        _ -> socket
      end

    changeset =
      %PersonTagging{}
      |> Persons.change_person_tagging(person_tagging_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"person_tagging" => extra_params}, socket) do
    case Persons.tag_person(socket.assigns.person, socket.assigns.person_tag, extra_params) do
      {:ok, _person_tag} ->
        {:noreply,
         socket
         |> put_flash(:info, "Relationship created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
