defmodule Crew.Activities.ActivitySlotRequirement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.Activity
  alias Crew.Locations.Location
  alias Crew.Persons.Person
  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_slot_requirements" do
    belongs_to :site, Site
    belongs_to :activity, Activity
    belongs_to :person, Person
    belongs_to :location, Location

    field :name, :string
    field :description, :string

    field :option_group, :integer

    field :location_gap_before_minutes, :integer
    field :location_gap_after_minutes, :integer

    field :person_gap_before_minutes, :integer
    field :person_gap_after_minutes, :integer

    timestamps()
  end

  @doc false
  def changeset(activity_slot_requirement, attrs) do
    activity_slot_requirement
    |> cast(attrs, [
      :name,
      :description,
      :option_group,
      :person_gap_before_minutes,
      :person_gap_after_minutes,
      :location_gap_before_minutes,
      :location_gap_after_minutes,
      :start_time
    ])
    |> validate_required([:name])
  end
end
