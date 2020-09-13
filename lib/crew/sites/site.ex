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
    field :primary_domain, :string

    field :discarded_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:name, :slug, :description, :primary_domain])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end

  def discard(obj) do
    change(obj, %{discarded_at: NaiveDateTime.utc_now()})
  end
end
