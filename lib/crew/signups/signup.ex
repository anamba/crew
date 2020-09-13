defmodule Crew.Signups.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.{Activity, ActivitySlot}
  alias Crew.Locations.Location
  alias Crew.Persons.Person
  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "signups" do
    belongs_to :site, Site
    belongs_to :guest, Person

    belongs_to :person, Person
    belongs_to :location, Location
    belongs_to :activity, Activity

    belongs_to :activity_slot, ActivitySlot
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

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
