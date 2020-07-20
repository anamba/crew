defmodule Crew.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "locations" do
    belongs_to :site, Site

    field :name, :string
    field :slug, :string
    field :description, :string

    field :capacity, :integer

    field :longitude, :decimal
    field :latitude, :decimal

    field :address1, :string
    field :address2, :string
    field :address3, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :postal_code, :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [
      :name,
      :slug,
      :description,
      :capacity,
      :address1,
      :address2,
      :address3,
      :city,
      :state,
      :postal_code,
      :country
    ])
    |> validate_required([:name, :slug])
  end
end
