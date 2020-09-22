defmodule Crew.Periods.Period do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site
  alias Crew.Periods.PeriodGroup

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "periods" do
    belongs_to :site, Site
    belongs_to :period_group, PeriodGroup

    field :name, :string
    field :slug, :string
    field :description, :string

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :string
    field :batch_note, :string

    timestamps()
  end

  @doc false
  def changeset(period, attrs) do
    period
    |> cast(attrs, [:period_group_id, :name, :slug, :description, :start_time, :end_time])
    |> validate_required([:name, :start_time, :end_time])
  end
end
