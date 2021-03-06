defmodule Crew.Sites do
  @moduledoc """
  The Sites context.
  """

  import Ecto.Query, warn: false
  alias Crew.Repo

  alias Crew.Sites.Site

  def site_query(), do: from(s in Site, where: is_nil(s.discarded_at))

  @doc """
  Returns the list of sites.

  ## Examples

      iex> list_sites()
      [%Site{}, ...]

  """
  def list_sites do
    Repo.all(site_query())
  end

  @doc """
  Gets a single site.

  Raises `Ecto.NoResultsError` if the Site does not exist.

  ## Examples

      iex> get_site!(123)
      %Site{}

      iex> get_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site!(id), do: Repo.get!(site_query(), id)
  def get_site(id), do: Repo.get(site_query(), id)

  def get_site_by(attrs), do: Repo.get_by(site_query(), attrs)

  @doc """
  Creates a site.

  ## Examples

      iex> create_site(%{field: value})
      {:ok, %Site{}}

      iex> create_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site(attrs \\ %{}) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site.

  ## Examples

      iex> update_site(site, %{field: new_value})
      {:ok, %Site{}}

      iex> update_site(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  def upsert_site(update_attrs \\ %{}, find_attrs = %{}) do
    case get_site_by(find_attrs) do
      nil -> create_site(Map.merge(find_attrs, update_attrs))
      existing -> update_site(existing, update_attrs)
    end
  end

  @doc """
  Deletes a site.

  ## Examples

      iex> delete_site(site)
      {:ok, %Site{}}

      iex> delete_site(site)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site(%Site{} = site) do
    # Repo.delete(site)
    Site.discard(site)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site changes.

  ## Examples

      iex> change_site(site)
      %Ecto.Changeset{data: %Site{}}

  """
  def change_site(%Site{} = site, attrs \\ %{}) do
    Site.changeset(site, attrs)
  end

  alias Crew.Sites.SiteMember

  @doc """
  Returns the list of site_members.

  ## Examples

      iex> list_site_members()
      [%SiteMember{}, ...]

  """
  def list_site_members do
    Repo.all(SiteMember)
  end

  @doc """
  Gets a single site_member.

  Raises `Ecto.NoResultsError` if the Site member does not exist.

  ## Examples

      iex> get_site_member!(123)
      %SiteMember{}

      iex> get_site_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site_member!(id), do: Repo.get!(SiteMember, id)

  def get_site_member!(site_id, user_id),
    do: Repo.get_by!(SiteMember, site_id: site_id, user_id: user_id)

  def fetch_site_member(site_id, user_id) do
    case Repo.get_by(SiteMember, site_id: site_id, user_id: user_id) do
      nil -> {:error, "not found"}
      site_member -> {:ok, site_member}
    end
  end

  def get_site_member_by(attrs, site_id),
    do: Repo.get_by(SiteMember, Map.merge(attrs, %{site_id: site_id}))

  @doc """
  Creates a site_member.

  ## Examples

      iex> create_site_member(%{field: value})
      {:ok, %SiteMember{}}

      iex> create_site_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site_member(attrs \\ %{}, site_id) do
    %SiteMember{}
    |> SiteMember.changeset(Map.merge(attrs, %{site_id: site_id}))
    |> Repo.insert()
  end

  @doc """
  Updates a site_member.

  ## Examples

      iex> update_site_member(site_member, %{field: new_value})
      {:ok, %SiteMember{}}

      iex> update_site_member(site_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site_member(%SiteMember{} = site_member, attrs) do
    site_member
    |> SiteMember.changeset(attrs)
    |> Repo.update()
  end

  def upsert_site_member(update_attrs \\ %{}, find_attrs = %{}, site_id) do
    case get_site_member_by(find_attrs, site_id) do
      nil -> create_site_member(Map.merge(find_attrs, update_attrs), site_id)
      existing -> update_site_member(existing, update_attrs)
    end
  end

  @doc """
  Deletes a site_member.

  ## Examples

      iex> delete_site_member(site_member)
      {:ok, %SiteMember{}}

      iex> delete_site_member(site_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site_member(%SiteMember{} = site_member) do
    Repo.delete(site_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site_member changes.

  ## Examples

      iex> change_site_member(site_member)
      %Ecto.Changeset{data: %SiteMember{}}

  """
  def change_site_member(%SiteMember{} = site_member, attrs \\ %{}) do
    SiteMember.changeset(site_member, attrs)
  end
end
