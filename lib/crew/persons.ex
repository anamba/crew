defmodule Crew.Persons do
  @moduledoc """
  The Persons context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Crew.Repo
  alias Crew.Persons.Person

  def person_query(site_id), do: from(p in Person, where: p.site_id == ^site_id)

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons()
      [%Person{}, ...]

  """
  def list_persons(site_id) do
    Repo.all(person_query(site_id))
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}, site_id) do
    %Person{}
    |> Person.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end

  alias Crew.Persons.PersonTag

  def person_tag_query(site_id), do: from(pt in PersonTag, where: pt.site_id == ^site_id)

  @doc """
  Returns the list of person_tags.

  ## Examples

      iex> list_person_tags()
      [%PersonTag{}, ...]

  """
  def list_person_tags(site_id) do
    Repo.all(person_tag_query(site_id))
  end

  @doc """
  Gets a single person_tag.

  Raises `Ecto.NoResultsError` if the Person tag does not exist.

  ## Examples

      iex> get_person_tag!(123)
      %PersonTag{}

      iex> get_person_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person_tag!(id), do: Repo.get!(PersonTag, id)
  def get_person_tag_by(attrs, site_id), do: Repo.get_by(person_tag_query(site_id), attrs)

  @doc """
  Creates a person_tag.

  ## Examples

      iex> create_person_tag(%{field: value})
      {:ok, %PersonTag{}}

      iex> create_person_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person_tag(attrs \\ %{}, site_id) do
    %PersonTag{}
    |> PersonTag.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a person_tag.

  ## Examples

      iex> update_person_tag(person_tag, %{field: new_value})
      {:ok, %PersonTag{}}

      iex> update_person_tag(person_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person_tag(%PersonTag{} = person_tag, attrs) do
    person_tag
    |> PersonTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person_tag.

  ## Examples

      iex> delete_person_tag(person_tag)
      {:ok, %PersonTag{}}

      iex> delete_person_tag(person_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person_tag(%PersonTag{} = person_tag) do
    Repo.delete(person_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person_tag changes.

  ## Examples

      iex> change_person_tag(person_tag)
      %Ecto.Changeset{data: %PersonTag{}}

  """
  def change_person_tag(%PersonTag{} = person_tag, attrs \\ %{}) do
    PersonTag.changeset(person_tag, attrs)
  end

  alias Crew.Persons.PersonRel

  @doc """
  Returns the list of person_rels.

  ## Examples

      iex> list_person_rels()
      [%PersonRel{}, ...]

  """
  def list_person_rels do
    Repo.all(PersonRel)
  end

  @doc """
  Gets a single person_rel.

  Raises `Ecto.NoResultsError` if the Person rel does not exist.

  ## Examples

      iex> get_person_rel!(123)
      %PersonRel{}

      iex> get_person_rel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person_rel!(id), do: Repo.get!(PersonRel, id)

  @doc """
  Creates a person_rel.

  ## Examples

      iex> create_person_rel(%{field: value})
      {:ok, %PersonRel{}}

      iex> create_person_rel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person_rel(attrs \\ %{}) do
    %PersonRel{}
    |> PersonRel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person_rel.

  ## Examples

      iex> update_person_rel(person_rel, %{field: new_value})
      {:ok, %PersonRel{}}

      iex> update_person_rel(person_rel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person_rel(%PersonRel{} = person_rel, attrs) do
    person_rel
    |> PersonRel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person_rel.

  ## Examples

      iex> delete_person_rel(person_rel)
      {:ok, %PersonRel{}}

      iex> delete_person_rel(person_rel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person_rel(%PersonRel{} = person_rel) do
    Repo.delete(person_rel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person_rel changes.

  ## Examples

      iex> change_person_rel(person_rel)
      %Ecto.Changeset{data: %PersonRel{}}

  """
  def change_person_rel(%PersonRel{} = person_rel, attrs \\ %{}) do
    PersonRel.changeset(person_rel, attrs)
  end
end
