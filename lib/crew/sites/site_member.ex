defmodule Crew.Sites.SiteMember do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "site_members" do
    belongs_to :site, Site
    belongs_to :person, Person

    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(site_member, attrs) do
    site_member
    |> cast(attrs, [:site_id, :person_id])
    |> validate_required([:site_id, :person_id])
  end
end
