defmodule Crew.Periods.PeriodGroup do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "period_groups" do
    belongs_to :site, Site

    field :name, :string
    field :slug, :string
    field :description, :string

    field :event, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(period_group, attrs) do
    period_group
    |> cast(attrs, [:name, :slug, :description, :event])
    |> validate_required([:name])
  end
end
