defmodule Crew.Periods.Period do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "periods" do
    field :description, :string
    field :end_time, :utc_datetime
    field :name, :string
    field :slug, :string
    field :start_time, :utc_datetime
    field :site_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(period, attrs) do
    period
    |> cast(attrs, [:name, :slug, :description, :start_time, :end_time])
    |> validate_required([:name, :slug, :description, :start_time, :end_time])
  end
end
