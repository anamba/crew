defmodule Crew.Sites.Site do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.SiteMember

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sites" do
    has_many :site_members, SiteMember

    field :description, :string
    field :name, :string
    field :slug, :string

    field :active, :boolean

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:name, :slug, :description, :active])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end
end
