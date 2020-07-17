defmodule Crew.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    field :description, :string
    field :max_duration_minutes, :integer
    field :min_duration_minutes, :integer
    field :name, :string
    field :slug, :string
    field :site_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:name, :slug, :description, :min_duration_minutes, :max_duration_minutes])
    |> validate_required([:name, :slug, :description, :min_duration_minutes, :max_duration_minutes])
  end
end
