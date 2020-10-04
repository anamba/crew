defmodule Crew.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Crew.Repo
  alias Crew.Activities.Activity

  def activity_query(site_id),
    do: from(a in Activity, where: a.site_id == ^site_id, order_by: a.name)

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities(site_id) do
    Repo.all(activity_query(site_id))
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id), do: Repo.get!(Activity, id)
  def get_activity_by(attrs, site_id), do: Repo.get_by(activity_query(site_id), attrs)

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs, site_id) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  def upsert_activity(find_attrs = %{}, update_attrs = %{}, site_id) do
    case get_activity_by(find_attrs, site_id) do
      nil -> create_activity(Map.merge(find_attrs, update_attrs), site_id)
      existing -> update_activity(existing, update_attrs)
    end
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end

  alias Crew.Activities.ActivityTag

  def activity_tag_query(site_id), do: from(at in ActivityTag, where: at.site_id == ^site_id)

  @doc """
  Returns the list of activity_tags.

  ## Examples

      iex> list_activity_tags()
      [%ActivityTag{}, ...]

  """
  def list_activity_tags(site_id) do
    Repo.all(activity_tag_query(site_id))
  end

  @doc """
  Gets a single activity_tag.

  Raises `Ecto.NoResultsError` if the Activity tag does not exist.

  ## Examples

      iex> get_activity_tag!(123)
      %ActivityTag{}

      iex> get_activity_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity_tag!(id), do: Repo.get!(ActivityTag, id)
  def get_activity_tag_by(attrs, site_id), do: Repo.get_by(activity_tag_query(site_id), attrs)

  @doc """
  Creates a activity_tag.

  ## Examples

      iex> create_activity_tag(%{field: value})
      {:ok, %ActivityTag{}}

      iex> create_activity_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_tag(attrs \\ %{}, site_id) do
    %ActivityTag{}
    |> ActivityTag.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a activity_tag.

  ## Examples

      iex> update_activity_tag(activity_tag, %{field: new_value})
      {:ok, %ActivityTag{}}

      iex> update_activity_tag(activity_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_tag(%ActivityTag{} = activity_tag, attrs) do
    activity_tag
    |> ActivityTag.changeset(attrs)
    |> Repo.update()
  end

  def upsert_activity_tag(find_attrs = %{}, update_attrs = %{}, site_id) do
    case get_activity_tag_by(find_attrs, site_id) do
      nil -> create_activity_tag(Map.merge(find_attrs, update_attrs), site_id)
      existing -> update_activity_tag(existing, update_attrs)
    end
  end

  @doc """
  Deletes a activity_tag.

  ## Examples

      iex> delete_activity_tag(activity_tag)
      {:ok, %ActivityTag{}}

      iex> delete_activity_tag(activity_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity_tag(%ActivityTag{} = activity_tag) do
    Repo.delete(activity_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_tag changes.

  ## Examples

      iex> change_activity_tag(activity_tag)
      %Ecto.Changeset{data: %ActivityTag{}}

  """
  def change_activity_tag(%ActivityTag{} = activity_tag, attrs \\ %{}) do
    ActivityTag.changeset(activity_tag, attrs)
  end

  alias Crew.Activities.ActivityTagGroup

  def activity_tag_group_query(site_id),
    do: from(atg in ActivityTagGroup, where: atg.site_id == ^site_id)

  @doc """
  Returns the list of activity_tag_groups.

  ## Examples

      iex> list_activity_tag_groups()
      [%ActivityTagGroup{}, ...]

  """
  def list_activity_tag_groups(site_id) do
    Repo.all(activity_tag_group_query(site_id))
  end

  @doc """
  Gets a single activity_tag_group.

  Raises `Ecto.NoResultsError` if the Activity tag group does not exist.

  ## Examples

      iex> get_activity_tag_group!(123)
      %ActivityTagGroup{}

      iex> get_activity_tag_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity_tag_group!(id), do: Repo.get!(ActivityTagGroup, id)

  @doc """
  Creates a activity_tag_group.

  ## Examples

      iex> create_activity_tag_group(%{field: value})
      {:ok, %ActivityTagGroup{}}

      iex> create_activity_tag_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_tag_group(attrs \\ %{}, site_id) do
    %ActivityTagGroup{}
    |> ActivityTagGroup.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a activity_tag_group.

  ## Examples

      iex> update_activity_tag_group(activity_tag_group, %{field: new_value})
      {:ok, %ActivityTagGroup{}}

      iex> update_activity_tag_group(activity_tag_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_tag_group(%ActivityTagGroup{} = activity_tag_group, attrs) do
    activity_tag_group
    |> ActivityTagGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity_tag_group.

  ## Examples

      iex> delete_activity_tag_group(activity_tag_group)
      {:ok, %ActivityTagGroup{}}

      iex> delete_activity_tag_group(activity_tag_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity_tag_group(%ActivityTagGroup{} = activity_tag_group) do
    Repo.delete(activity_tag_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_tag_group changes.

  ## Examples

      iex> change_activity_tag_group(activity_tag_group)
      %Ecto.Changeset{data: %ActivityTagGroup{}}

  """
  def change_activity_tag_group(%ActivityTagGroup{} = activity_tag_group, attrs \\ %{}) do
    ActivityTagGroup.changeset(activity_tag_group, attrs)
  end

  alias Crew.Activities.TimeSlot

  def time_slot_query(site_id),
    do:
      from(as in TimeSlot,
        where: as.site_id == ^site_id,
        preload: [:period, :activity, :person, :location]
      )

  def time_slot_batch_query(batch_id),
    do:
      from(as in TimeSlot,
        where: as.batch_id == ^batch_id,
        preload: [:period, :activity, :person, :location]
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

  def list_time_slots_by_batch(site_id) do
    time_slot_query(site_id)
    |> Repo.all()
    |> Enum.group_by(&{&1.start_time_local, &1.end_time_local, &1.batch_id})
    |> Enum.sort()
  end

  def list_time_slots_in_batch(batch_id) do
    Repo.all(time_slot_batch_query(batch_id))
  end

  # TODO: create other versions that preset fields based on Activity, Location, Person
  def new_time_slot(%Crew.Sites.Site{} = site) do
    time_zone = site.default_time_zone
    now = DateTime.now!(time_zone)
    %TimeSlot{time_zone: time_zone, start_time_local: now, end_time_local: now}
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
    do: Repo.get!(TimeSlot, id)

  def get_time_slot_by(attrs, site_id),
    do:
      Repo.get_by(time_slot_query(site_id), attrs)
      |> Repo.preload([:activity, :person, :location])

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
    |> create_time_slot_batch()
  end

  def create_time_slot_batch(changeset) do
    # create time slots for entity ids (just activity_ids for now)
    activity_ids = get_field(changeset, :activity_ids)

    new_records =
      for activity_id <- activity_ids do
        {:ok, _time_slot} =
          changeset
          |> put_change(:activity_id, activity_id)
          |> Repo.insert()
      end

    List.last(new_records)
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
    |> update_time_slot_batch(attrs)
  end

  def update_time_slot_batch(changeset, attrs) do
    activity_ids = get_field(changeset, :activity_ids)
    {:ok, original_slot} = Repo.update(changeset)

    # find all time slots currently in batch
    batch = list_time_slots_in_batch(get_field(changeset, :batch_id))

    # delete any time slots that do not match the selected association ids (just activity_ids for now)
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

    for activity_id <- missing_ids do
      data =
        original_slot
        |> Map.from_struct()
        |> Map.merge(%{activity_id: activity_id})
        |> Map.delete("activity_ids")

      {:ok, _time_slot} =
        %TimeSlot{}
        |> TimeSlot.changeset(data)
        |> put_change(:site_id, original_slot.site_id)
        |> Repo.insert()
    end

    {:ok, original_slot}
  end

  def upsert_time_slot(find_attrs = %{}, update_attrs = %{}, site_id) do
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

  alias Crew.Activities.TimeSlotRequirement

  @doc """
  Gets a single time_slot_requirement.

  Raises `Ecto.NoResultsError` if the Time Slot requirement does not exist.

  ## Examples

      iex> get_time_slot_requirement!(123)
      %TimeSlotRequirement{}

      iex> get_time_slot_requirement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_time_slot_requirement!(id), do: Repo.get!(TimeSlotRequirement, id)

  @doc """
  Creates a time_slot_requirement.

  ## Examples

      iex> create_time_slot_requirement(%{field: value})
      {:ok, %TimeSlotRequirement{}}

      iex> create_time_slot_requirement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_time_slot_requirement(attrs \\ %{}, %TimeSlot{id: time_slot_id}) do
    %TimeSlotRequirement{}
    |> TimeSlotRequirement.changeset(attrs)
    |> put_change(:time_slot_id, time_slot_id)
    |> Repo.insert()
  end

  @doc """
  Updates a time_slot_requirement.

  ## Examples

      iex> update_time_slot_requirement(time_slot_requirement, %{field: new_value})
      {:ok, %TimeSlotRequirement{}}

      iex> update_time_slot_requirement(time_slot_requirement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_time_slot_requirement(
        %TimeSlotRequirement{} = time_slot_requirement,
        attrs
      ) do
    time_slot_requirement
    |> TimeSlotRequirement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a time_slot_requirement.

  ## Examples

      iex> delete_time_slot_requirement(time_slot_requirement)
      {:ok, %TimeSlotRequirement{}}

      iex> delete_time_slot_requirement(time_slot_requirement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_time_slot_requirement(%TimeSlotRequirement{} = time_slot_requirement) do
    Repo.delete(time_slot_requirement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking time_slot_requirement changes.

  ## Examples

      iex> change_time_slot_requirement(time_slot_requirement)
      %Ecto.Changeset{data: %TimeSlotRequirement{}}

  """
  def change_time_slot_requirement(
        %TimeSlotRequirement{} = time_slot_requirement,
        attrs \\ %{}
      ) do
    TimeSlotRequirement.changeset(time_slot_requirement, attrs)
  end
end
