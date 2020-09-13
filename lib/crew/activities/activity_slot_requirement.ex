defmodule Crew.Activities.ActivitySlotRequirement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.{ActivitySlot, ActivityTag}
  alias Crew.Persons.PersonTag

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_slot_requirements" do
    belongs_to :activity_slot, ActivitySlot

    belongs_to :activity_tag, ActivityTag
    belongs_to :person_tag, PersonTag

    field :name, :string
    field :description, :string

    # requirements with same group number will be ORed together (default is AND)
    field :option_group, :integer

    field :location_gap_before_minutes, :integer
    field :location_gap_after_minutes, :integer

    field :person_gap_before_minutes, :integer
    field :person_gap_after_minutes, :integer

    field :person_tag_value, :string
    field :person_tag_value_i, :integer

    timestamps()
  end

  @doc false
  def changeset(activity_slot_requirement, attrs) do
    activity_slot_requirement
    |> cast(attrs, [
      :activity_tag_id,
      :person_tag_id,
      :name,
      :description,
      :option_group,
      :location_gap_before_minutes,
      :location_gap_after_minutes,
      :person_gap_before_minutes,
      :person_gap_after_minutes,
      :person_tag_value,
      :person_tag_value_i
    ])
    |> validate_required([:name])
  end
end
