defmodule Crew.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    belongs_to :site, Site

    field :name, :string
    field :slug, :string
    field :description, :string

    field :min_duration_minutes, :integer
    field :max_duration_minutes, :integer

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:name, :slug, :description, :min_duration_minutes, :max_duration_minutes])
    |> validate_required([:name])
  end
end
