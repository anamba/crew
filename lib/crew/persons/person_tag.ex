defmodule Crew.Persons.PersonTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "person_tags" do
    belongs_to :site, Site

    field :name, :string
    field :description, :string

    field :internal_use_only, :boolean, default: true
    field :self_assignable, :boolean, default: false

    # for self-assignable tags, optionally allow user to enter a custom value
    field :value_label, :string

    # can be a string value (free text or select, e.g. T-Shirt Size)
    field :has_value, :boolean, default: false, null: false
    field :value_choices_json, :string

    # or an integer (e.g. grad year, number of guests)
    field :has_value_i, :boolean, default: false, null: false
    field :value_i_min, :integer
    field :value_i_max, :integer

    timestamps()
  end

  @doc false
  def changeset(person_tag, attrs) do
    person_tag
    |> cast(attrs, [
      :name,
      :description,
      :internal_use_only,
      :self_assignable,
      :value_label,
      :has_value,
      :has_value_i,
      :value_choices_json,
      :value_i_min,
      :value_i_max
    ])
    |> validate_required([:name])
  end
end
