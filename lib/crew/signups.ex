defmodule Crew.Signups do
  @moduledoc """
  The Signups context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Crew.Repo
  alias Crew.Signups.Signup

  def signup_query(site_id),
    do:
      from(s in Signup,
        where: s.site_id == ^site_id,
        preload: [:guest, :activity, :location, :person, :time_slot]
      )

  @doc """
  Returns the list of signups.

  ## Examples

      iex> list_signups()
      [%Signup{}, ...]

  """
  def list_signups(site_id) do
    Repo.all(signup_query(site_id))
  end

  def list_signups_for_time_slot(time_slot_id) do
    from(s in Signup,
      where: s.time_slot_id == ^time_slot_id,
      preload: [:guest, :activity, :location, :person]
    )
  end

  def count_signups_for_time_slot(nil), do: 0

  def count_signups_for_time_slot(time_slot_id) do
    count =
      from(s in Signup,
        where: s.time_slot_id == ^time_slot_id,
        select: [:guest_count]
      )
      |> Repo.aggregate(:sum, :guest_count)

    if count, do: Decimal.to_integer(count), else: 0
  end

  def signups_for_guest_query(
        guest_id,
        include_related \\ false,
        range_start \\ nil,
        range_end \\ nil
      ) do
    guest_ids =
      [guest_id] ++
        if include_related do
          Crew.Persons.list_persons_related_to_person_id(guest_id)
          |> Enum.map(& &1.id)
        else
          []
        end

    query =
      from(s in Signup,
        where: s.guest_id in ^guest_ids,
        order_by: [desc: :updated_at],
        preload: [:guest, :activity, :location, :person, :time_slot]
      )

    query =
      if range_start,
        do: from(s in query, where: s.end_time > ^range_start),
        else: query

    if range_end,
      do: from(s in query, where: s.start_time < ^range_end),
      else: query
  end

  def list_signups_for_guest(
        guest_id,
        include_related \\ false,
        range_start \\ nil,
        range_end \\ nil
      ) do
    Repo.all(signups_for_guest_query(guest_id, include_related, range_start, range_end))
  end

  def count_signups_for_guest(
        guest_id,
        include_related \\ false,
        range_start \\ nil,
        range_end \\ nil
      ) do
    query = signups_for_guest_query(guest_id, include_related, range_start, range_end)
    Repo.one(from s in query, select: count(s.id))
  end

  @doc """
  Gets a single signup.

  Raises `Ecto.NoResultsError` if the Signup does not exist.

  ## Examples

      iex> get_signup!(123)
      %Signup{}

      iex> get_signup!(456)
      ** (Ecto.NoResultsError)

  """
  def get_signup!(id), do: Repo.get!(from(s in Signup, preload: [:guest, :time_slot]), id)

  @doc """
  Creates a signup.

  ## Examples

      iex> create_signup(%{field: value})
      {:ok, %Signup{}}

      iex> create_signup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def bare_create_signup(attrs, site_id) do
    %Signup{}
    |> Signup.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  def create_signup(attrs, site_id) do
    with {:ok, signup} <- bare_create_signup(attrs, site_id),
         signup <- Crew.Repo.preload(signup, [:time_slot]) do
      Crew.Activities.update_time_slot_availability(signup.time_slot)
      {:ok, signup}
    else
      err -> err
    end
  end

  def create_linked_signups(attrs, guest_ids, site_id),
    do: create_linked_signups(attrs, guest_ids, Ecto.UUID.generate(), site_id)

  def create_linked_signups(_attrs, [], _batch_id, _site_id), do: []

  def create_linked_signups(attrs, [guest_id | guest_ids], batch_id, site_id) do
    IO.inspect(guest_id, label: "guest_id")
    IO.inspect(guest_ids, label: "guest_ids")

    attrs =
      attrs
      |> Map.put(:guest_id, guest_id)
      |> Map.put(:batch_id, batch_id)

    with {:ok, signup} <- create_signup(attrs, site_id) do
      [{:ok, signup} | create_linked_signups(attrs, guest_ids, batch_id, site_id)]
    else
      err -> err
    end
  end

  @doc """
  Updates a signup.

  ## Examples

      iex> update_signup(signup, %{field: new_value})
      {:ok, %Signup{}}

      iex> update_signup(signup, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def bare_update_signup(%Signup{} = signup, attrs) do
    signup
    |> Signup.changeset(attrs)
    |> Repo.update()
  end

  def update_signup(%Signup{} = signup, attrs) do
    with {:ok, signup} <- bare_update_signup(signup, attrs) do
      Crew.Activities.update_time_slot_availability(signup.time_slot)
      {:ok, signup}
    else
      err -> err
    end
  end

  @doc """
  Deletes a signup.

  ## Examples

      iex> delete_signup(signup)
      {:ok, %Signup{}}

      iex> delete_signup(signup)
      {:error, %Ecto.Changeset{}}

  """
  def bare_delete_signup(%Signup{} = signup) do
    Repo.delete(signup)
  end

  def delete_signup(%Signup{} = signup) do
    with {:ok, signup} <- bare_delete_signup(signup) do
      Crew.Activities.update_time_slot_availability(signup.time_slot)
      {:ok, signup}
    else
      err -> err
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking signup changes.

  ## Examples

      iex> change_signup(signup)
      %Ecto.Changeset{data: %Signup{}}

  """
  def change_signup(%Signup{} = signup, attrs \\ %{}) do
    Signup.changeset(signup, attrs)
  end

  def change_signup(%Signup{} = signup, attrs, site_id) do
    change_signup(signup, attrs)
    |> put_change(:site_id, site_id)
  end
end
