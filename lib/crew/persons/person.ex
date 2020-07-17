defmodule Crew.Persons.Person do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.SiteMember

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "persons" do
    belongs_to :site_member, SiteMember

    field :first_name, :string
    field :last_name, :string
    field :middle_names, :string
    field :note, :string
    field :profile, :string
    field :suffix, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:title, :first_name, :middle_names, :last_name, :suffix, :note, :profile])
    |> validate_required([
      :title,
      :first_name,
      :middle_names,
      :last_name,
      :suffix,
      :note,
      :profile
    ])
  end
end
