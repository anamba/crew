defmodule Crew.Helpers.LocalTime do
  use Ecto.Schema
  import Ecto.Changeset

  def validate_time_range(changeset) do
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

  def local_to_utc(changeset, local_field, utc_field) do
    # NOTE: only do this conversion on change
    new_value = get_change(changeset, local_field)
    tz = get_field(changeset, :time_zone)

    put_local_to_utc(changeset, utc_field, new_value, tz)
  end

  def put_local_to_utc(changeset, _, nil, _), do: changeset
  def put_local_to_utc(changeset, _, _, nil), do: changeset

  def put_local_to_utc(changeset, utc_field, new_value, timezone) do
    utc_value = DateTime.from_naive!(new_value, timezone) |> Timex.Timezone.convert("UTC")
    put_change(changeset, utc_field, utc_value)
  end

  def utc_to_local(changeset, utc_field, local_field) do
    # NOTE: do this conversion anytime we call changeset
    new_value = get_field(changeset, utc_field)
    tz = get_field(changeset, :time_zone)

    put_utc_to_local(changeset, local_field, new_value, tz)
  end

  def put_utc_to_local(changeset, _, nil, _), do: changeset
  def put_utc_to_local(changeset, _, _, nil), do: changeset

  def put_utc_to_local(changeset, local_field, new_value, timezone) do
    local_value = Timex.Timezone.convert(new_value, timezone) |> DateTime.to_naive()
    put_change(changeset, local_field, local_value)
  end
end
