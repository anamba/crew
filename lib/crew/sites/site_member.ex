defmodule Crew.Sites.SiteMember do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Accounts.User
  alias Crew.Persons.Person
  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "site_members" do
    belongs_to :site, Site
    belongs_to :user, User

    # associate User with Person
    belongs_to :person, Person

    field :role, :string

    field :active, :boolean

    timestamps()
  end

  @doc false
  def changeset(site_member, attrs) do
    site_member
    |> cast(attrs, [:site_id, :user_id, :person_id, :role])
    |> validate_required([:site_id, :user_id])
  end
end
