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

    field :start_time_local, :naive_datetime
    field :end_time_local, :naive_datetime
    field :time_zone, :string

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
    |> local_to_utc(:start_time_local, :start_time)
    |> local_to_utc(:end_time_local, :end_time)
    |> validate_required([:guest_id, :start_time, :end_time])
    |> validate_time_range()
    |> utc_to_local(:start_time, :start_time_local)
    |> utc_to_local(:end_time, :end_time_local)
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

  defp local_to_utc(changeset, local_field, utc_field) do
    # NOTE: only do this conversion on change
    new_value = get_change(changeset, local_field)
    tz = get_field(changeset, :time_zone)

    put_local_to_utc(changeset, utc_field, new_value, tz)
  end

  defp put_local_to_utc(changeset, _, nil, _), do: changeset
  defp put_local_to_utc(changeset, _, _, nil), do: changeset

  defp put_local_to_utc(changeset, utc_field, new_value, timezone) do
    utc_value = DateTime.from_naive!(new_value, timezone) |> Timex.Timezone.convert("UTC")
    put_change(changeset, utc_field, utc_value)
  end

  defp utc_to_local(changeset, utc_field, local_field) do
    # NOTE: do this conversion anytime we call changeset
    new_value = get_field(changeset, utc_field)
    tz = get_field(changeset, :time_zone)

    put_utc_to_local(changeset, local_field, new_value, tz)
  end

  defp put_utc_to_local(changeset, _, nil, _), do: changeset
  defp put_utc_to_local(changeset, _, _, nil), do: changeset

  defp put_utc_to_local(changeset, local_field, new_value, timezone) do
    local_value = Timex.Timezone.convert(new_value, timezone) |> DateTime.to_naive()
    put_change(changeset, local_field, local_value)
  end
end
