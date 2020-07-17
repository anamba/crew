defmodule Crew.Persons.PersonTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "person_tags" do
    field :description, :string
    field :name, :string
    field :self_assignable, :boolean, default: false
    field :site_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(person_tag, attrs) do
    person_tag
    |> cast(attrs, [:name, :description, :self_assignable])
    |> validate_required([:name, :description, :self_assignable])
  end
end
