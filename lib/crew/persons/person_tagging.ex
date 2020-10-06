defmodule Crew.Persons.PersonTagging do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Persons.{Person, PersonTag}

  @foreign_key_type :binary_id
  schema "person_taggings" do
    belongs_to :person, Person
    belongs_to :tag, PersonTag, foreign_key: :person_tag_id

    field :value, :string
    field :value_i, :integer

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :binary_id
    field :batch_note, :string

    timestamps()
  end

  @doc false
  def changeset(person_tagging, attrs) do
    person_tagging
    |> cast(attrs, [:person_id, :person_tag_id, :value, :value_i])
    |> validate_required([:person_id, :person_tag_id])
  end
end
