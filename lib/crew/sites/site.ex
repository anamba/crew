defmodule Crew.Sites.Site do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.SiteMember

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sites" do
    has_many :site_members, SiteMember

    field :name, :string
    field :slug, :string
    field :description, :string

    field :primary_domain, :string
    field :sender_email, :string

    field :default_time_zone, :string

    field :closed, :boolean, default: false

    field :discarded_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [
      :name,
      :slug,
      :description,
      :primary_domain,
      :sender_email,
      :default_time_zone,
      :closed
    ])
    |> validate_required([:name, :slug, :primary_domain])
    |> unique_constraint(:slug)
  end

  def discard(obj) do
    change(obj, %{discarded_at: DateTime.utc_now() |> DateTime.truncate(:second)})
  end
end
