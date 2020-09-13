defmodule Crew.Activities.ActivitySlot do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.Activity
  alias Crew.Locations.Location
  alias Crew.Persons.Person
  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_slots" do
    belongs_to :site, Site

    # select at least one of these to tie this slot to a particular object
    # (the limiting factor, i.e. the reason we need a scheduling system)
    belongs_to :activity, Activity
    belongs_to :location, Location
    belongs_to :person, Person

    field :name, :string
    field :description, :string

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(activity_slot, attrs) do
    activity_slot
    |> cast(attrs, [
      :activity_id,
      :location_id,
      :person_id,
      :name,
      :description,
      :start_time,
      :end_time
    ])
    |> validate_required([:name, :start_time, :end_time])
  end
end
