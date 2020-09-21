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
        preload: [:guest, :person, :location, :activity]
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

  @doc """
  Gets a single signup.

  Raises `Ecto.NoResultsError` if the Signup does not exist.

  ## Examples

      iex> get_signup!(123)
      %Signup{}

      iex> get_signup!(456)
      ** (Ecto.NoResultsError)

  """
  def get_signup!(id), do: Repo.get!(from(s in Signup, preload: [:guest]), id)

  @doc """
  Creates a signup.

  ## Examples

      iex> create_signup(%{field: value})
      {:ok, %Signup{}}

      iex> create_signup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_signup(attrs, site_id) do
    %Signup{}
    |> Signup.changeset(attrs)
    |> put_change(:site_id, site_id)
    |> Repo.insert()
  end

  @doc """
  Updates a signup.

  ## Examples

      iex> update_signup(signup, %{field: new_value})
      {:ok, %Signup{}}

      iex> update_signup(signup, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_signup(%Signup{} = signup, attrs) do
    signup
    |> Signup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a signup.

  ## Examples

      iex> delete_signup(signup)
      {:ok, %Signup{}}

      iex> delete_signup(signup)
      {:error, %Ecto.Changeset{}}

  """
  def delete_signup(%Signup{} = signup) do
    Repo.delete(signup)
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
