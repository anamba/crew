defmodule Crew.Activities.ActivityTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_tags" do
    belongs_to :site, Site

    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(activity_tag, attrs) do
    activity_tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
