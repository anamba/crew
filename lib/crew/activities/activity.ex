defmodule Crew.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.{ActivityTagging}
  alias Crew.Sites.Site
  alias Crew.Signups.Signup
  alias Crew.TimeSlots.TimeSlot

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    belongs_to :site, Site
    has_many :time_slots, TimeSlot
    has_many :signups, Signup
    has_many :activity_taggings, ActivityTagging
    has_many :tags, through: [:activity_taggings, :activity_tag]

    field :name, :string
    field :slug, :string
    field :description, :string

    field :min_duration_minutes, :integer, default: 25
    field :max_duration_minutes, :integer, default: 25
    field :duration_increment_minutes, :integer, default: 15

    field :closed, :boolean, default: false

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :binary_id
    field :batch_note, :string

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:name, :slug, :description, :min_duration_minutes, :max_duration_minutes])
    |> validate_required([:name])
  end
end
