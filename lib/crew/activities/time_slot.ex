defmodule Crew.Activities.TimeSlot do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.Activity
  alias Crew.Locations.Location
  alias Crew.Persons.Person
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

    has_many :signups, Signup

    field :name, :string
    field :description, :string

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    field :start_time_local, :naive_datetime
    field :end_time_local, :naive_datetime
    field :time_zone, :string

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
      :location_id,
      :person_id,
      :name,
      :description,
      :start_time,
      :end_time,
      :start_time_local,
      :end_time_local,
      :time_zone,
      :batch_id
    ])
    |> local_to_utc(:start_time_local, :start_time)
    |> local_to_utc(:end_time_local, :end_time)
    |> validate_required([:start_time, :end_time])
    |> validate_time_range()
    |> utc_to_local(:start_time, :start_time_local)
    |> utc_to_local(:end_time, :end_time_local)
    |> put_name()
    |> put_batch_id()
    |> put_activity_ids()
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

  defp put_name(changeset) do
    start_time_local = get_field(changeset, :start_time_local)
    end_time_local = get_field(changeset, :end_time_local)

    if start_time_local && end_time_local do
      end_time_format =
        if NaiveDateTime.to_date(start_time_local) == NaiveDateTime.to_date(end_time_local),
          do: "%-I:%M %p",
          else: "%Y-%m-%d %-I:%M %p"

      put_change(
        changeset,
        :name,
        "#{Timex.format!(start_time_local, "%Y-%m-%d %-I:%M %p", :strftime)} – #{
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

  defp put_activity_ids(changeset) do
    cond do
      activity_ids = get_change(changeset, :activity_ids) ->
        put_change(changeset, :activity_ids, Enum.filter(activity_ids, &(&1 != "false")))

      activity_id = get_change(changeset, :activity_id) ->
        put_change(changeset, :activity_ids, [activity_id])

      true ->
        batch_id = get_field(changeset, :batch_id)
        batch = Crew.Activities.list_time_slots_in_batch(batch_id)

        put_change(
          changeset,
          :activity_ids,
          Enum.map(batch, & &1.activity_id) |> Enum.filter(& &1) |> Enum.uniq()
        )
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
