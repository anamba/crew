defmodule Crew.TimeSlots do
  @moduledoc """
  The TimeSlots context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Crew.Activities.Activity
  alias Crew.Persons
  alias Crew.Persons.PersonTag
  alias Crew.Repo
  alias Crew.TimeSlots.TimeSlot

  @time_slot_default_preload [:activity, :person, :location, :activity_tag, :person_tag]

  def subscribe(site_id) do
    Phoenix.PubSub.subscribe(Crew.PubSub, "site-#{site_id}-time_slots")
  end

  def time_slot_query(site_id),
    do:
      from(ts in TimeSlot,
        where: ts.site_id == ^site_id,
        order_by: ts.start_time,
        preload: ^@time_slot_default_preload
      )

  def future_time_slot_query(site_id),
    do: from(ts in time_slot_query(site_id), where: ts.end_time > ^Timex.now())

  def time_slot_batch_query(batch_id),
    do:
      from(ts in TimeSlot,
        join: a in Activity,
        on: ts.activity_id == a.id,
        where: ts.batch_id == ^batch_id,
        order_by: [a.name, ts.start_time],
        preload: ^@time_slot_default_preload
      )

  @doc """
  Returns the list of time_slots.

  ## Examples

      iex> list_time_slots()
      [%TimeSlot{}, ...]

  """
  def list_time_slots(site_id) do
    Repo.all(time_slot_query(site_id))
  end

  def list_time_slots(minimum_signups_available, site_id)
      when is_integer(minimum_signups_available) do
    from(ts in time_slot_query(site_id), where: ^minimum_signups_available <= ts.signups_available)
    |> Repo.all()
  end

  def list_future_time_slots_for_persons_ids(
        person_ids,
        show_unavailable \\ false,
        union_or_intersection \\ :union
      )
      when is_list(person_ids) and length(person_ids) > 0 do
    persons = Enum.map(person_ids, &Persons.get_person!(&1, [:taggings]))
    site_id = List.first(persons).site_id

    query = from(ts in future_time_slot_query(site_id))

    query =
      if show_unavailable do
        query
      else
        from ts in query, where: ^length(persons) <= ts.signups_available
      end

    taggings =
      Enum.map(persons, fn person ->
        tags_and_values = Enum.map(person.taggings, &{&1.person_tag_id, &1.value, &1.value_i})
        MapSet.new(tags_and_values)
      end)
      |> Enum.reduce(&apply(MapSet, union_or_intersection, [&1, &2]))

    Repo.all(query)
    |> Repo.preload([:person_tag])
    |> Enum.filter(fn slot ->
      case {slot.person_tag, slot.person_tag_value, slot.person_tag_value_i} do
        {nil, _, _} ->
          true

        {%PersonTag{id: tag_id, has_value: true}, value, _} when not is_nil(value) ->
          Enum.all?(taggings, fn {id, req_value, _} ->
            (id == tag_id && ((req_value || "") == "" || req_value == value)) || id != tag_id
          end)

        {%PersonTag{id: tag_id, has_value_i: true}, _, value_i} when not is_nil(value_i) ->
          Enum.all?(taggings, fn {id, _, req_value_i} ->
            (id == tag_id && ((req_value_i || "") == "" || req_value_i == value_i)) ||
              id != tag_id
          end)

        {%PersonTag{id: tag_id}, _, _} ->
          Enum.any?(taggings, fn {id, _, _} -> id == tag_id end)

        other ->
          false
      end
    end)
  end

  def list_time_slots_by_batch(site_id) do
    time_slot_query(site_id)
    |> Repo.all()
    |> Enum.group_by(&{&1.start_time_local, &1.end_time_local, &1.batch_id})
    |> Enum.map(fn {key, records} -> {key, Enum.sort_by(records, &entity_name_tuple/1)} end)
    |> Enum.sort()
  end

  defp entity_name_tuple(time_slot) do
    {time_slot.activity && time_slot.activity.name, time_slot.location && time_slot.location.name,
     time_slot.person && time_slot.person.name}
  end

  def list_time_slots_in_batch(batch_id) do
    Repo.all(time_slot_batch_query(batch_id))
  end

  # TODO: create other versions that preset fields based on Activity, Location, Person
  def new_time_slot(%Crew.Sites.Site{} = site) do
    time_zone = site.default_time_zone
    now = DateTime.now!(time_zone)

    %TimeSlot{
      time_zone: time_zone,
      start_time_local: now,
      end_time_local: Timex.shift(now, hours: 1)
    }
  end

  @doc """
  Gets a single time_slot.

  Raises `Ecto.NoResultsError` if the Time Slot does not exist.

  ## Examples

      iex> get_time_slot!(123)
      %TimeSlot{}

      iex> get_time_slot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_time_slot!(id),
    do:
      Repo.get!(TimeSlot, id)
      |> Repo.preload(@time_slot_default_preload)

  def get_time_slot(id),
    do:
      Repo.get(TimeSlot, id)
      |> Repo.preload(@time_slot_default_preload)

  def get_time_slot_by(attrs, site_id) when is_map(attrs),
    do: get_time_slot_by(Map.to_list(filter_nils(attrs)), site_id)

  def get_time_slot_by(attrs, site_id),
    do:
      from(t in time_slot_query(site_id),
        where: ^attrs,
        preload: ^@time_slot_default_preload
      )
      |> first()
      |> Repo.one()

  def get_slot_by_batch_id_and_activity_id(batch_id, activity_id)
      when not is_nil(batch_id) and not is_nil(activity_id) do
    [time_slot | _] =
      batch_id
      |> list_time_slots_in_batch()
      |> Enum.filter(&(&1.activity_id == activity_id))

    time_slot
  end

  defp filter_nils(map = %{}) do
    map
    |> Enum.filter(fn {_k, v} -> v end)
    |> Map.new()
  end

  @doc """
  Creates a time_slot.

  ## Examples

      iex> create_time_slot(%{field: value})
      {:ok, %TimeSlot{}}

      iex> create_time_slot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_time_slot(attrs \\ %{}, site_id) do
    %TimeSlot{}
    |> TimeSlot.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  def create_time_slot_batch(attrs \\ %{}, site_id) do
    changeset =
      %TimeSlot{}
      |> TimeSlot.batch_changeset(attrs)
      |> put_change(:site_id, site_id)

    # create time slots for entity ids (just activity_ids for now)
    activity_ids = get_field(changeset, :activity_ids)

    new_records =
      for activity_id <- activity_ids do
        changeset
        |> put_change(:activity_id, activity_id)
        |> Repo.insert()
      end

    List.first(new_records) || {:error, changeset}
  end

  @doc """
  Updates a time_slot.

  ## Examples

      iex> update_time_slot(time_slot, %{field: new_value})
      {:ok, %TimeSlot{}}

      iex> update_time_slot(time_slot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_time_slot(%TimeSlot{} = time_slot, attrs) do
    time_slot
    |> TimeSlot.changeset(attrs)
    |> Repo.update()
  end

  # do the math and send a pubsub broadcast on the availability channel for this site
  def update_time_slot_availability(time_slot) do
    {:ok, time_slot} =
      time_slot
      |> TimeSlot.availability_changeset()
      |> Repo.update()

    Phoenix.PubSub.broadcast(
      Crew.PubSub,
      "site-#{time_slot.site_id}-time_slots",
      {__MODULE__, "time_slot-changed", Repo.preload(time_slot, @time_slot_default_preload)}
    )

    {:ok, time_slot}
  end

  def update_time_slot_batch(%TimeSlot{} = time_slot, attrs) do
    changeset = TimeSlot.batch_changeset(time_slot, attrs)

    case Repo.update(changeset) do
      {:ok, original_slot} -> continue_update_time_slot_batch(original_slot, changeset, attrs)
      {:error, changeset} -> {:error, changeset}
    end
  end

  def continue_update_time_slot_batch(original_slot, changeset, attrs) do
    # find all time slots currently in batch
    batch = list_time_slots_in_batch(get_field(changeset, :batch_id))

    # delete any time slots that do not match the selected association ids (just activity_ids for now)
    activity_ids = get_field(changeset, :activity_ids)

    batch =
      for time_slot <- batch do
        cond do
          time_slot.activity_id in activity_ids ->
            time_slot

          true ->
            # if someone has already signed up for this slot, we have to skip it
            unless Enum.any?(Repo.preload(time_slot, [:signups]).signups) do
              {:ok, _time_slot} = Repo.delete(time_slot)
              nil
            end
        end
      end
      |> Enum.filter(& &1)

    # loop through the remaining ones and update them
    for time_slot <- batch do
      {:ok, _time_slot} =
        time_slot
        |> TimeSlot.changeset(attrs)
        |> Repo.update()
    end

    # create time slots for missing ids (just activity_ids for now)
    missing_ids = activity_ids -- Enum.map(batch, & &1.activity_id)

    # re-fetch as bare map
    original_slot_as_map =
      from(ts in TimeSlot,
        select:
          map(ts, [
            :period_id,
            # :activity_id,
            # :activity_ids,
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
      )
      |> Repo.get!(original_slot.id)

    for activity_id <- missing_ids do
      data =
        original_slot_as_map
        |> Map.merge(%{activity_id: activity_id})

      {:ok, _time_slot} =
        upsert_time_slot(
          %{name: original_slot.name, activity_id: activity_id},
          data,
          original_slot.site_id
        )
    end

    {:ok, original_slot}
  end

  def upsert_time_slot(update_attrs \\ %{}, find_attrs = %{}, site_id) do
    case get_time_slot_by(find_attrs, site_id) do
      nil -> create_time_slot(Map.merge(find_attrs, update_attrs), site_id)
      existing -> update_time_slot(existing, update_attrs)
    end
  end

  @doc """
  Deletes a time_slot.

  ## Examples

      iex> delete_time_slot(time_slot)
      {:ok, %TimeSlot{}}

      iex> delete_time_slot(time_slot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_time_slot(%TimeSlot{} = time_slot) do
    Repo.delete(time_slot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking time_slot changes.

  ## Examples

      iex> change_time_slot(time_slot)
      %Ecto.Changeset{data: %TimeSlot{}}

  """
  def change_time_slot(%TimeSlot{} = time_slot, attrs \\ %{}) do
    TimeSlot.changeset(time_slot, attrs)
  end

  def change_time_slot_batch(%TimeSlot{} = time_slot, attrs \\ %{}) do
    TimeSlot.batch_changeset(time_slot, attrs)
  end
end
