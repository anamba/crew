defmodule Crew.Periods.Period do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "periods" do
    belongs_to :site, Site

    field :name, :string
    field :slug, :string
    field :description, :string

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(period, attrs) do
    period
    |> cast(attrs, [:name, :slug, :description, :start_time, :end_time])
    |> validate_required([:name, :start_time, :end_time])
  end
end
