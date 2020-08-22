defmodule Crew.Persons.PersonTagging do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Persons.{Person, PersonTag}

  @foreign_key_type :binary_id
  schema "person_taggings" do
    belongs_to :person, Person
    belongs_to :person_tag, PersonTag

    timestamps()
  end

  @doc false
  def changeset(person_tagging, attrs) do
    person_tagging
    |> cast(attrs, [:person_id, :person_tag_id])
    |> validate_required([:person_id, :person_tag_id])
  end
end
