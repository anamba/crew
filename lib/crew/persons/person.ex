defmodule Crew.Persons.Person do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Persons.PersonTagging
  alias Crew.Sites.Site

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "persons" do
    belongs_to :site, Site
    has_many :person_taggings, PersonTagging
    has_many :tags, through: [:person_taggings, :tag]

    field :title, :string
    field :first_name, :string
    field :middle_names, :string
    field :last_name, :string
    field :suffix, :string

    field :preferred_name, :string
    field :preferred_pronouns, :string

    field :note, :string
    field :profile, :string

    field :notification_email, :string

    # for custom fields
    field :metadata_json, :string

    # vs. physical, i.e. can be in more than one place at once
    field :virtual, :boolean, default: false

    # i.e. not an individual
    field :group, :boolean, default: false

    # ties together a set of records imported together, so that we can a failed import in one step
    field :batch_uuid, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:title, :first_name, :middle_names, :last_name, :suffix, :note, :profile])
    |> validate_required([:first_name, :last_name])
  end
end
