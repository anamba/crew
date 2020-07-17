defmodule Crew.Persons.PersonRel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "person_rels" do
    field :metadata, :string
    field :verb, :string
    field :src_person_id, :binary_id
    field :dest_person_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(person_rel, attrs) do
    person_rel
    |> cast(attrs, [:verb, :metadata])
    |> validate_required([:verb, :metadata])
  end
end
