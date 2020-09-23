defmodule Crew.Signups.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.{Activity, TimeSlot}
  alias Crew.Locations.Location
  alias Crew.Persons.Person
  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "signups" do
    belongs_to :site, Site
    belongs_to :guest, Person

    belongs_to :person, Person
    belongs_to :location, Location
    belongs_to :activity, Activity

    belongs_to :time_slot, TimeSlot
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    field :last_reminded_at, :utc_datetime

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :string
    field :batch_note, :string

    timestamps()
  end

  @doc false
  def changeset(signup, attrs) do
    signup
    |> cast(attrs, [
      :site_id,
      :guest_id,
      :person_id,
      :location_id,
      :activity_id,
      :time_slot_id,
      :start_time,
      :end_time
    ])
    |> validate_required([:guest_id, :start_time, :end_time])
    |> validate_time_range()
  end

  defp validate_time_range(changeset) do
    start_time = get_field(changeset, :start_time)

    validate_change(changeset, :end_time, fn :end_time, end_time ->
      cond do
        is_nil(start_time) or is_nil(end_time) -> []
        DateTime.compare(start_time, end_time) == :lt -> []
        true -> [end_time: "must be after start time"]
      end
    end)
  end
end
