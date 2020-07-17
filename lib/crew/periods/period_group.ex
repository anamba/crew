defmodule Crew.Periods.PeriodGroup do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "period_groups" do
    field :description, :string
    field :event, :boolean, default: false
    field :name, :string
    field :slug, :string
    field :site_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(period_group, attrs) do
    period_group
    |> cast(attrs, [:name, :slug, :description, :event])
    |> validate_required([:name, :slug, :description, :event])
  end
end
