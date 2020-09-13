defmodule Crew.Persons.PersonRel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Persons.Person

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "person_rels" do
    belongs_to :src_person, Person
    belongs_to :dest_person, Person

    field :verb, :string
    field :metadata, :string

    timestamps()
  end

  @doc false
  def changeset(person_rel, attrs) do
    person_rel
    |> cast(attrs, [:src_person_id, :verb, :dest_person_id, :metadata])
    |> validate_required([:src_person_id, :verb, :dest_person_id])
  end
end
