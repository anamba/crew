defmodule Crew.Signups.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site
  alias Crew.Persons.Person

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "signups" do
    belongs_to :site, Site
    belongs_to :person, Person

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :activity_id, :binary_id
    field :activity_slot_id, :binary_id
    field :last_reminded_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(signup, attrs) do
    signup
    |> cast(attrs, [:start_time, :end_time, :last_reminded_at])
    |> validate_required([:start_time, :end_time, :last_reminded_at])
  end
end
