defmodule Crew.Activities.ActivityTagGroup do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_tag_groups" do
    belongs_to :site, Site

    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(activity_tag_group, attrs) do
    activity_tag_group
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
