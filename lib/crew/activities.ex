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

  def upsert_activity(update_attrs \\ %{}, find_attrs = %{}, site_id) do
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

  def upsert_activity_tag(update_attrs \\ %{}, find_attrs = %{}, site_id) do
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
end
