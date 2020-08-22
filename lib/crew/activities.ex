defmodule Crew.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Crew.Repo
  alias Crew.Activities.Activity

  def activity_query(site_id), do: from(a in Activity, where: a.site_id == ^site_id)

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

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}, site_id) do
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

  alias Crew.Activities.ActivitySlot

  def activity_slot_query(site_id), do: from(as in ActivitySlot, where: as.site_id == ^site_id)

  @doc """
  Returns the list of activity_slots.

  ## Examples

      iex> list_activity_slots()
      [%ActivitySlot{}, ...]

  """
  def list_activity_slots(site_id) do
    Repo.all(activity_slot_query(site_id))
  end

  @doc """
  Gets a single activity_slot.

  Raises `Ecto.NoResultsError` if the Activity slot does not exist.

  ## Examples

      iex> get_activity_slot!(123)
      %ActivitySlot{}

      iex> get_activity_slot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity_slot!(id), do: Repo.get!(ActivitySlot, id)

  @doc """
  Creates a activity_slot.

  ## Examples

      iex> create_activity_slot(%{field: value})
      {:ok, %ActivitySlot{}}

      iex> create_activity_slot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_slot(attrs \\ %{}, site_id) do
    %ActivitySlot{}
    |> ActivitySlot.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a activity_slot.

  ## Examples

      iex> update_activity_slot(activity_slot, %{field: new_value})
      {:ok, %ActivitySlot{}}

      iex> update_activity_slot(activity_slot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_slot(%ActivitySlot{} = activity_slot, attrs) do
    activity_slot
    |> ActivitySlot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity_slot.

  ## Examples

      iex> delete_activity_slot(activity_slot)
      {:ok, %ActivitySlot{}}

      iex> delete_activity_slot(activity_slot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity_slot(%ActivitySlot{} = activity_slot) do
    Repo.delete(activity_slot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_slot changes.

  ## Examples

      iex> change_activity_slot(activity_slot)
      %Ecto.Changeset{data: %ActivitySlot{}}

  """
  def change_activity_slot(%ActivitySlot{} = activity_slot, attrs \\ %{}) do
    ActivitySlot.changeset(activity_slot, attrs)
  end

  alias Crew.Activities.ActivitySlotRequirement

  @doc """
  Gets a single activity_slot_requirement.

  Raises `Ecto.NoResultsError` if the Activity slot requirement does not exist.

  ## Examples

      iex> get_activity_slot_requirement!(123)
      %ActivitySlotRequirement{}

      iex> get_activity_slot_requirement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity_slot_requirement!(id), do: Repo.get!(ActivitySlotRequirement, id)

  @doc """
  Creates a activity_slot_requirement.

  ## Examples

      iex> create_activity_slot_requirement(%{field: value})
      {:ok, %ActivitySlotRequirement{}}

      iex> create_activity_slot_requirement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_slot_requirement(attrs \\ %{}, %ActivitySlot{id: activity_slot_id}) do
    %ActivitySlotRequirement{}
    |> ActivitySlotRequirement.changeset(attrs)
    |> put_change(:activity_slot_id, activity_slot_id)
    |> Repo.insert()
  end

  @doc """
  Updates a activity_slot_requirement.

  ## Examples

      iex> update_activity_slot_requirement(activity_slot_requirement, %{field: new_value})
      {:ok, %ActivitySlotRequirement{}}

      iex> update_activity_slot_requirement(activity_slot_requirement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_slot_requirement(
        %ActivitySlotRequirement{} = activity_slot_requirement,
        attrs
      ) do
    activity_slot_requirement
    |> ActivitySlotRequirement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity_slot_requirement.

  ## Examples

      iex> delete_activity_slot_requirement(activity_slot_requirement)
      {:ok, %ActivitySlotRequirement{}}

      iex> delete_activity_slot_requirement(activity_slot_requirement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity_slot_requirement(%ActivitySlotRequirement{} = activity_slot_requirement) do
    Repo.delete(activity_slot_requirement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity_slot_requirement changes.

  ## Examples

      iex> change_activity_slot_requirement(activity_slot_requirement)
      %Ecto.Changeset{data: %ActivitySlotRequirement{}}

  """
  def change_activity_slot_requirement(
        %ActivitySlotRequirement{} = activity_slot_requirement,
        attrs \\ %{}
      ) do
    ActivitySlotRequirement.changeset(activity_slot_requirement, attrs)
  end
end
