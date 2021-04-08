defmodule Crew.Periods.Period do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Helpers.LocalTime

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

    field :time_zone, :string
    field :start_time_local, :naive_datetime
    field :end_time_local, :naive_datetime

    field :closed, :boolean, default: false

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :binary_id
    field :batch_note, :string

    timestamps()
  end

  @doc false
  def changeset(period, attrs) do
    period
    |> cast(attrs, [
      :period_group_id,
      :name,
      :slug,
      :description,
      :start_time,
      :end_time,
      :time_zone,
      :start_time_local,
      :end_time_local,
      :batch_id
    ])
    |> LocalTime.local_to_utc(:start_time_local, :start_time)
    |> LocalTime.local_to_utc(:end_time_local, :end_time)
    |> validate_required([:name, :start_time, :end_time])
    |> LocalTime.validate_time_range()
    |> LocalTime.utc_to_local(:start_time, :start_time_local)
    |> LocalTime.utc_to_local(:end_time, :end_time_local)
  end
end
