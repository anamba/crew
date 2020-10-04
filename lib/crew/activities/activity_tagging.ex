defmodule Crew.Activities.ActivityTagging do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Activities.{Activity, ActivityTag}

  @foreign_key_type :binary_id
  schema "activity_taggings" do
    belongs_to :activity, Activity
    belongs_to :activity_tag, ActivityTag

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :binary_id
    field :batch_note, :string

    timestamps()
  end

  @doc false
  def changeset(activity_tagging, attrs) do
    activity_tagging
    |> cast(attrs, [:activity_id, :activity_tag_id])
    |> validate_required([:activity_id, :activity_tag_id])
  end
end
