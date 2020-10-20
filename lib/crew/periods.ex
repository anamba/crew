defmodule Crew.Periods do
  @moduledoc """
  The Periods context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Crew.Repo

  alias Crew.Periods.Period

  def period_query(site_id), do: from(p in Period, where: p.site_id == ^site_id)

  @doc """
  Returns the list of periods.

  ## Examples

      iex> list_periods()
      [%Period{}, ...]

  """
  def list_periods(site_id) do
    Repo.all(period_query(site_id))
  end

  @doc """
  Gets a single period.

  Raises `Ecto.NoResultsError` if the Period does not exist.

  ## Examples

      iex> get_period!(123)
      %Period{}

      iex> get_period!(456)
      ** (Ecto.NoResultsError)

  """
  def get_period!(id), do: Repo.get!(Period, id)
  def get_period_by(attrs, site_id), do: Repo.get_by(period_query(site_id), attrs)

  @doc """
  Creates a period.

  ## Examples

      iex> create_period(%{field: value})
      {:ok, %Period{}}

      iex> create_period(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_period(attrs \\ %{}, site_id) do
    %Period{}
    |> Period.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a period.

  ## Examples

      iex> update_period(period, %{field: new_value})
      {:ok, %Period{}}

      iex> update_period(period, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_period(%Period{} = period, attrs) do
    period
    |> Period.changeset(attrs)
    |> Repo.update()
  end

  def upsert_period(update_attrs \\ %{}, find_attrs = %{}, site_id) do
    case get_period_by(find_attrs, site_id) do
      nil -> create_period(Map.merge(find_attrs, update_attrs), site_id)
      existing -> update_period(existing, update_attrs)
    end
  end

  @doc """
  Deletes a period.

  ## Examples

      iex> delete_period(period)
      {:ok, %Period{}}

      iex> delete_period(period)
      {:error, %Ecto.Changeset{}}

  """
  def delete_period(%Period{} = period) do
    Repo.delete(period)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking period changes.

  ## Examples

      iex> change_period(period)
      %Ecto.Changeset{data: %Period{}}

  """
  def change_period(%Period{} = period, attrs \\ %{}) do
    Period.changeset(period, attrs)
  end

  alias Crew.Periods.PeriodGroup

  def period_group_query(site_id), do: from(pg in PeriodGroup, where: pg.site_id == ^site_id)

  @doc """
  Returns the list of period_groups.

  ## Examples

      iex> list_period_groups()
      [%PeriodGroup{}, ...]

  """
  def list_period_groups(site_id) do
    Repo.all(period_group_query(site_id))
  end

  @doc """
  Gets a single period_group.

  Raises `Ecto.NoResultsError` if the Period group does not exist.

  ## Examples

      iex> get_period_group!(123)
      %PeriodGroup{}

      iex> get_period_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_period_group!(id), do: Repo.get!(PeriodGroup, id)
  def get_period_group_by(attrs, site_id), do: Repo.get_by(period_group_query(site_id), attrs)

  @doc """
  Creates a period_group.

  ## Examples

      iex> create_period_group(%{field: value})
      {:ok, %PeriodGroup{}}

      iex> create_period_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_period_group(attrs \\ %{}, site_id) do
    %PeriodGroup{}
    |> PeriodGroup.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a period_group.

  ## Examples

      iex> update_period_group(period_group, %{field: new_value})
      {:ok, %PeriodGroup{}}

      iex> update_period_group(period_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_period_group(%PeriodGroup{} = period_group, attrs) do
    period_group
    |> PeriodGroup.changeset(attrs)
    |> Repo.update()
  end

  def upsert_period_group(update_attrs \\ %{}, find_attrs = %{}, site_id) do
    case get_period_group_by(find_attrs, site_id) do
      nil -> create_period_group(Map.merge(find_attrs, update_attrs), site_id)
      existing -> update_period_group(existing, update_attrs)
    end
  end

  @doc """
  Deletes a period_group.

  ## Examples

      iex> delete_period_group(period_group)
      {:ok, %PeriodGroup{}}

      iex> delete_period_group(period_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_period_group(%PeriodGroup{} = period_group) do
    Repo.delete(period_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking period_group changes.

  ## Examples

      iex> change_period_group(period_group)
      %Ecto.Changeset{data: %PeriodGroup{}}

  """
  def change_period_group(%PeriodGroup{} = period_group, attrs \\ %{}) do
    PeriodGroup.changeset(period_group, attrs)
  end
end
