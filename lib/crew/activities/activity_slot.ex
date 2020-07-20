defmodule Crew.Activities.ActivitySlot do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_slots" do
    belongs_to :site, Site

    field :name, :string
    field :description, :string

    field :start_time, :time
    field :end_time, :time

    timestamps()
  end

  @doc false
  def changeset(activity_slot, attrs) do
    activity_slot
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
