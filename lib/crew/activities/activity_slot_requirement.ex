defmodule Crew.Activities.ActivitySlotRequirement do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_slot_requirements" do
    field :description, :string
    field :location_gap_after_minutes, :integer
    field :location_gap_before_minutes, :integer
    field :name, :string
    field :option_group, :integer
    field :person_gap_after_minutes, :integer
    field :person_gap_before_minutes, :integer
    field :start_time, :time
    field :site_id, :binary_id
    field :activity_id, :binary_id
    field :person_id, :binary_id
    field :location_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(activity_slot_requirement, attrs) do
    activity_slot_requirement
    |> cast(attrs, [:name, :description, :option_group, :person_gap_before_minutes, :person_gap_after_minutes, :location_gap_before_minutes, :location_gap_after_minutes, :start_time])
    |> validate_required([:name, :description, :option_group, :person_gap_before_minutes, :person_gap_after_minutes, :location_gap_before_minutes, :location_gap_after_minutes, :start_time])
  end
end
