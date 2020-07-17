defmodule Crew.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "locations" do
    field :address1, :string
    field :address2, :string
    field :address3, :string
    field :capacity, :integer
    field :city, :string
    field :country, :string
    field :description, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :postal_code, :string
    field :slug, :string
    field :state, :string
    field :site_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :slug, :description, :longitude, :latitude, :capacity, :address1, :address2, :address3, :city, :state, :postal_code, :country])
    |> validate_required([:name, :slug, :description, :longitude, :latitude, :capacity, :address1, :address2, :address3, :city, :state, :postal_code, :country])
  end
end
