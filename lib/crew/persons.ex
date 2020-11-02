defmodule Crew.Persons do
  @moduledoc """
  The Persons context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Crew.Repo
  alias Crew.Persons.{Person, PersonTag, PersonTagging, PersonRel}

  def person_query(site_id),
    do:
      from(p in Person,
        where: p.site_id == ^site_id and is_nil(p.discarded_at),
        order_by: [desc: :updated_at]
      )

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons()
      [%Person{}, ...]

  """
  def list_persons(preload \\ [], page \\ 1, per_page \\ 100, site_id) do
    offset = per_page * (page - 1)

    from(p in person_query(site_id), limit: ^per_page, offset: ^offset, preload: ^preload)
    |> Repo.all()
  end

  # NOTE: this version (currently the only version) takes an id
  def list_persons_related_to_person(person_id, preload \\ []) do
    dest_persons =
      from(r in PersonRel, where: r.src_person_id == ^person_id, preload: [dest_person: ^preload])
      |> Repo.all()
      |> Enum.map(& &1.dest_person)

    src_persons =
      from(r in PersonRel, where: r.dest_person_id == ^person_id, preload: [src_person: ^preload])
      |> Repo.all()
      |> Enum.map(& &1.src_person)

    dest_persons ++ src_persons
  end

  def search(query_str, preload \\ [], page \\ 1, per_page \\ 100, site_id) do
    offset = per_page * (page - 1)
    query = from(p in person_query(site_id), limit: ^per_page, offset: ^offset, preload: ^preload)

    query_terms =
      query_str
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(&String.downcase/1)

    add_search_terms_to_query = fn term, query ->
      term = String.replace(term, "%", "")
      term = "%#{term}%"
      from(p in query, where: like(p.search_index, ^term))
    end

    Enum.reduce(query_terms, query, add_search_terms_to_query)
    |> Repo.all()
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
  def get_person(nil), do: nil
  def get_person(id), do: Repo.get(Person, id)

  def get_person_by(attrs, site_id),
    do: Repo.get_by(person_query(site_id), attrs) |> Repo.preload(:site)

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs, site_id) do
    %Person{}
    |> Person.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  def get_or_create_person_for_confirm_email(email, site_id) when is_binary(email) do
    case get_person_by(%{email: email}, site_id) || get_person_by(%{new_email: email}, site_id) do
      nil -> create_person_for_confirm_email(email, site_id)
      existing_person -> {:ok, existing_person}
    end
  end

  def create_person_for_confirm_email(email, site_id) when is_binary(email) do
    %Person{}
    |> Person.change_email_changeset(%{new_email: email})
    |> put_change(:site, Crew.Sites.get_site!(site_id))
    |> Repo.insert()
  end

  def change_email(person, email) when is_binary(email) do
    person
    |> Person.change_email_changeset(%{new_email: email})
    |> Repo.update()
  end

  def confirm_email(%Person{new_email: _} = person) do
    person
    |> Person.confirm_email()
    |> Repo.update()
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

  def change_person_profile(%Person{} = person, attrs \\ %{}) do
    person
    |> Person.profile_changeset(attrs)
  end

  def update_person_profile(%Person{} = person, attrs) do
    person
    |> Person.profile_changeset(attrs)
    |> Repo.update()
  end

  def upsert_person(update_attrs \\ %{}, find_attrs = %{}, site_id) do
    case get_person_by(find_attrs, site_id) do
      nil -> create_person(Map.merge(find_attrs, update_attrs), site_id)
      existing -> update_person(existing, update_attrs)
    end
  end

  def reindex_person(%Person{} = person) do
    Person.reindex_changeset(person)
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
    # Repo.delete(person)
    Person.discard(person)
    |> Repo.update()
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

  def change_person(%Person{} = person, attrs, site_id) do
    change_person(person, attrs)
    |> put_change(:site_id, site_id)
  end

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
  def get_person_tag(nil), do: nil
  def get_person_tag(id), do: Repo.get(PersonTag, id)
  def get_person_tag_by(attrs, site_id), do: Repo.get_by(person_tag_query(site_id), attrs)

  @doc """
  Creates a person_tag. (Use upsert_person_tag/3 instead.)

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
  Updates a person_tag. (Use upsert_person_tag/3 instead.)

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

  def upsert_person_tag(update_attrs \\ %{}, find_attrs = %{}, site_id) do
    case get_person_tag_by(find_attrs, site_id) do
      nil -> create_person_tag(Map.merge(find_attrs, update_attrs), site_id)
      existing -> update_person_tag(existing, update_attrs)
    end
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

  def tag_person(
        %Person{id: person_id, site_id: sid},
        %PersonTag{site_id: sid, id: tag_id, name: name},
        extra_attrs
      ) do
    attrs = %{person_id: person_id, person_tag_id: tag_id}
    extra_attrs = Map.put(extra_attrs, :name, name)

    result =
      case Repo.get_by(PersonTagging, attrs) do
        nil ->
          %PersonTagging{person_id: person_id, person_tag_id: tag_id}
          |> PersonTagging.changeset(extra_attrs)
          |> Repo.insert()

        existing ->
          existing
          |> PersonTagging.changeset(extra_attrs)
          |> Repo.update()
      end

    case result do
      {:ok, person_tagging} ->
        Repo.preload(person_tagging, [:person]).person
        |> Repo.preload(:taggings)
        |> reindex_person()

        result

      _ ->
        result
    end
  end

  def untag_person(%Person{id: person_id, site_id: sid}, %PersonTag{site_id: sid, id: tag_id}) do
    attrs = %{person_id: person_id, tag_id: tag_id}

    case Repo.get_by(PersonTagging, attrs) do
      nil -> nil
      existing -> Repo.delete(existing)
    end
  end

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
  def get_person_rel_by(attrs), do: Repo.get_by(PersonRel, attrs)

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

  def upsert_person_rel(
        %Person{site_id: sid, id: srcid},
        src_label,
        dest_label,
        %Person{site_id: sid, id: destid},
        metadata \\ %{}
      ) do
    find_attrs = %{
      src_person_id: srcid,
      src_label: src_label,
      dest_label: dest_label,
      dest_person_id: destid
    }

    case get_person_rel_by(find_attrs) do
      nil -> create_person_rel(Map.merge(metadata, find_attrs))
      existing -> update_person_rel(existing, metadata)
    end
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
