defmodule Crew.Activities.ActivityTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_tags" do
    field :description, :string
    field :name, :string
    field :site_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(activity_tag, attrs) do
    activity_tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
