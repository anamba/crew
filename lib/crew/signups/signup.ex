defmodule Crew.Signups.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.{Activity, TimeSlot}
  alias Crew.Locations.Location
  alias Crew.{Persons, Persons.Person}
  alias Crew.Signups
  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "signups" do
    belongs_to :site, Site
    belongs_to :guest, Person
    field :guest_count, :integer, default: 1

    belongs_to :person, Person
    belongs_to :location, Location
    belongs_to :activity, Activity

    field :name, :string
    field :note, :string

    belongs_to :time_slot, TimeSlot
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    field :start_time_local, :naive_datetime
    field :end_time_local, :naive_datetime
    field :time_zone, :string

    field :last_reminded_at, :utc_datetime

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :binary_id
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
    |> put_field_from_time_slot(:start_time)
    |> put_field_from_time_slot(:end_time)
    |> put_field_from_time_slot(:time_zone)
    |> validate_required([:guest_id, :time_slot_id, :start_time, :end_time])
    |> validate_time_range()
    |> validate_guest()
    |> validate_location()
    |> validate_time_slot()
    |> utc_to_local(:start_time, :start_time_local)
    |> utc_to_local(:end_time, :end_time_local)
    |> put_name()
  end

  defp put_name(%{valid?: false} = changeset), do: changeset

  defp put_name(changeset) do
    start_time = get_field(changeset, :start_time_local)
    # guest_name = get_field(changeset, :guest_id) |> Persons.get_person()
    put_change(changeset, :name, Timex.format!(start_time, "%a %Y-%m-%d %-I:%M%P", :strftime))
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

  defp validate_guest(changeset) do
    validate_change(changeset, :guest_id, fn :guest_id, guest_id ->
      guest = Persons.get_person(guest_id)
      start_time = get_field(changeset, :start_time)
      end_time = get_field(changeset, :end_time)

      # check for conflicts, unless virtual
      if guest && !guest.virtual do
        # find conflicting signups
        conflicts = Signups.list_signups_for_guest(guest.id, true, start_time, end_time)

        if conflict = List.first(conflicts) do
          [guest_id: "conflicts with existing signup: #{conflict.name}"]
        else
          []
        end
      else
        []
      end
    end)
  end

  defp validate_location(changeset) do
    # TODO: check # of signups against capacity
    changeset
  end

  defp validate_time_slot(changeset) do
    # TODO: check against signup_maximum, location_gap_before/after_minutes, person_gap_before/after_minutes
    changeset
  end

  defp put_field_from_time_slot(changeset, field) do
    time_slot = Crew.Activities.get_time_slot!(get_field(changeset, :time_slot_id))

    if get_field(changeset, field) do
      changeset
    else
      put_change(changeset, field, Map.from_struct(time_slot)[field])
    end
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
