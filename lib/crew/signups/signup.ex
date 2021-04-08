defmodule Crew.Signups.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Helpers.LocalTime

  alias Crew.Activities.Activity
  alias Crew.Locations.Location
  alias Crew.{Persons, Persons.Person}
  alias Crew.Repo
  alias Crew.Signups
  alias Crew.Sites.Site
  alias Crew.{TimeSlots, TimeSlots.TimeSlot}

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

    # to allow records that were created together to be viewed/edited/deleted together as well
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
      :start_time_local,
      :end_time,
      :end_time_local,
      :time_zone,
      :guest_count,
      :batch_id
    ])
    |> LocalTime.local_to_utc(:start_time_local, :start_time)
    |> LocalTime.local_to_utc(:end_time_local, :end_time)
    |> validate_required([:guest_id, :time_slot_id])
    |> copy_from_time_slot([
      :start_time,
      :end_time,
      :time_zone,
      :activity_id,
      :location_id,
      :person_id
    ])
    |> validate_required([:start_time, :end_time, :time_zone])
    |> LocalTime.validate_time_range()
    |> validate_guest()
    |> validate_location()
    |> validate_time_slot()
    |> LocalTime.utc_to_local(:start_time, :start_time_local)
    |> LocalTime.utc_to_local(:end_time, :end_time_local)
    |> put_name()
  end

  # note: ideally, preload before calling
  def closed?(signup) do
    signup = Repo.preload(signup, [:site, :activity, time_slot: [:period]])

    signup.site.closed || (signup.activity && signup.activity.closed) ||
      (signup.time_slot &&
         (signup.time_slot.closed || (signup.time_slot.period && signup.time_slot.period.closed)))
  end

  defp put_name(%{valid?: false} = changeset), do: changeset

  defp put_name(changeset) do
    start_time = get_field(changeset, :start_time_local)
    # guest_name = get_field(changeset, :guest_id) |> Persons.get_person()
    put_change(changeset, :name, Timex.format!(start_time, "%a %Y-%m-%d %-I:%M%P", :strftime))
  end

  defp validate_guest(changeset) do
    validate_change(changeset, :guest_id, fn :guest_id, guest_id ->
      guest = Persons.get_person(guest_id)
      start_time = get_field(changeset, :start_time)
      end_time = get_field(changeset, :end_time)

      # check for conflicts, unless virtual
      if guest && !guest.virtual do
        # find conflicting signups (for this person only)
        conflicts = Signups.list_signups_for_guest(guest.id, false, start_time, end_time)

        if conflict = List.first(conflicts) do
          [guest_id: "Conflict with existing signup (#{conflict.name})"]
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

  defp copy_from_time_slot(changeset, fields) do
    time_slot_id = get_field(changeset, :time_slot_id)

    case time_slot_id && TimeSlots.get_time_slot(time_slot_id) do
      nil ->
        changeset

      time_slot ->
        Enum.reduce(fields, changeset, fn field, changeset ->
          put_field_from_time_slot(changeset, time_slot, field)
        end)
    end
  end

  defp put_field_from_time_slot(%{valid?: false} = changeset, _time_slot, _field), do: changeset

  defp put_field_from_time_slot(changeset, time_slot, field) do
    # 2021-01-26: originally wanted to copy in values only if the corresponding signup fields
    #             were blank, but right now we don't have any other way to update these fields
    #             when the time slot changes, so just copy over everything every time.
    # if get_field(changeset, field) do
    # changeset
    # else
    put_change(changeset, field, Map.from_struct(time_slot)[field])
    # end
  end
end
