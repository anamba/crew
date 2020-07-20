defmodule Crew.Persons.PersonTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "person_tags" do
    belongs_to :site, Site

    field :name, :string
    field :description, :string

    field :self_assignable, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(person_tag, attrs) do
    person_tag
    |> cast(attrs, [:name, :description, :self_assignable])
    |> validate_required([:name])
  end
end
