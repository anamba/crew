defmodule Crew.Activities.TimeSlot do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.{Activity, ActivityTag}
  alias Crew.Locations.Location
  alias Crew.Persons.{Person, PersonTag}
  alias Crew.Periods.Period
  alias Crew.Signups.Signup
  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "time_slots" do
    belongs_to :site, Site
    belongs_to :period, Period

    # select at least one of these to tie this slot to a particular object
    # (the limiting factor, i.e. the reason we need a scheduling system)
    belongs_to :activity, Activity
    belongs_to :location, Location
    belongs_to :person, Person

    # these references are optional and add a requirement for signups on this Time Slot
    belongs_to :activity_tag, ActivityTag
    belongs_to :person_tag, PersonTag

    field :person_tag_value, :string
    field :person_tag_value_i, :integer

    has_many :signups, Signup

    field :name, :string
    field :description, :string

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    field :start_time_local, :naive_datetime
    field :end_time_local, :naive_datetime
    field :time_zone, :string

    # signup_target and signup_maximum limit/allow/encourage overbooking
    # for scheduling appointments, set target = 1, maximum = 1
    # for a class, work shift, etc. enter how many people you would like to have and the max capacity
    field :signup_target, :integer, default: 1
    field :signup_maximum, :integer, default: 1

    # if false, each signup will take up the entire time slot
    # eventually, these defaults will be controlled at the site or period group level
    # field :allow_division, :boolean, default: true
    field :allow_division, :boolean, default: false

    # cached estimate of how many more people could sign up given constraints
    field :signups_available, :integer

    field :location_gap_before_minutes, :integer
    field :location_gap_after_minutes, :integer

    field :person_gap_before_minutes, :integer
    field :person_gap_after_minutes, :integer

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :binary_id
    field :batch_note, :string
    field :activity_ids, :any, virtual: true

    timestamps()
  end

  @doc false
  def changeset(time_slot, attrs) do
    time_slot
    |> cast(attrs, [
      :period_id,
      :activity_id,
      :activity_ids,
      :activity_tag_id,
      :location_id,
      :person_id,
      :person_tag_id,
      :person_tag_value,
      :person_tag_value_i,
      :name,
      :description,
      :start_time,
      :end_time,
      :start_time_local,
      :end_time_local,
      :time_zone,
      :signup_target,
      :allow_division,
      :signup_maximum,
      :location_gap_before_minutes,
      :location_gap_after_minutes,
      :person_gap_before_minutes,
      :person_gap_after_minutes,
      :batch_id
    ])
    |> local_to_utc(:start_time_local, :start_time)
    |> local_to_utc(:end_time_local, :end_time)
    |> validate_required([:start_time, :end_time])
    # TODO: validate presence of either activity or activity tag
    |> validate_time_range()
    |> utc_to_local(:start_time, :start_time_local)
    |> utc_to_local(:end_time, :end_time_local)
    |> put_name()
    |> put_batch_id()
    |> put_signups_available()
  end

  @doc false
  def batch_changeset(time_slot, attrs) do
    changeset(time_slot, attrs)
    |> put_activity_ids()
  end

  def availability_changeset(time_slot) do
    time_slot
    |> change()
    |> put_signups_available()
  end

  defp put_name(changeset) do
    start_time_local = get_field(changeset, :start_time_local)
    end_time_local = get_field(changeset, :end_time_local)

    if start_time_local && end_time_local do
      start_time_format =
        if Timex.format!(start_time_local, "%p", :strftime) ==
             Timex.format!(end_time_local, "%p", :strftime),
           do: "%a %Y-%m-%d %-I:%M",
           else: "%a %Y-%m-%d %-I:%M%P"

      end_time_format =
        if NaiveDateTime.to_date(start_time_local) == NaiveDateTime.to_date(end_time_local),
          do: "%-I:%M%P",
          else: "%a %Y-%m-%d %-I:%M%P"

      put_change(
        changeset,
        :name,
        "#{Timex.format!(start_time_local, start_time_format, :strftime)} – #{
          Timex.format!(end_time_local, end_time_format, :strftime)
        }"
      )
    else
      changeset
    end
  end

  defp put_batch_id(changeset) do
    if get_field(changeset, :batch_id) do
      changeset
    else
      put_change(changeset, :batch_id, Ecto.UUID.generate())
    end
  end

  defp put_signups_available(changeset) do
    max = get_field(changeset, :signup_maximum) || 1
    count = Crew.Signups.count_signups_for_time_slot(changeset.data.id)
    put_change(changeset, :signups_available, max - count)
  end

  defp put_activity_ids(changeset) do
    activity_ids = get_field(changeset, :activity_ids)

    changeset =
      cond do
        # saving multiple slots
        !is_nil(activity_ids) and is_list(activity_ids) ->
          put_change(
            changeset,
            :activity_ids,
            Enum.filter(activity_ids, &(&1 != "false"))
          )

        # saving/loading a single slot, which could actually part of a batch (let's find out)
        true ->
          batch_id = get_field(changeset, :batch_id)
          batch = Crew.Activities.list_time_slots_in_batch(batch_id)

          put_change(
            changeset,
            :activity_ids,
            Enum.map(batch, & &1.activity_id) |> Enum.filter(& &1) |> Enum.uniq()
          )
      end

    validate_change(changeset, :activity_ids, fn :activity_ids, value ->
      cond do
        is_nil(value) or value == [] ->
          [activity_ids: "one or more is required"]

        true ->
          []
      end
    end)
  end

  defp validate_time_range(changeset) do
    changeset
    |> validate_change(:start_time, fn :start_time, start_time ->
      end_time = get_field(changeset, :end_time)

      cond do
        is_nil(start_time) or is_nil(end_time) -> []
        DateTime.compare(start_time, end_time) == :lt -> []
        true -> [start_time: "must be before end time"]
      end
    end)
    |> validate_change(:end_time, fn :end_time, end_time ->
      start_time = get_field(changeset, :start_time)

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
