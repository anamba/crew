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

    field :name, :string

    field :title, :string
    field :first_name, :string
    field :middle_names, :string
    field :last_name, :string
    field :suffix, :string

    field :preferred_name, :string
    field :preferred_pronouns, :string

    # the way we got the name in the file
    field :original_name, :string

    field :note, :string
    field :profile, :string

    field :notification_email, :string

    # for custom fields
    field :metadata_json, :string

    # vs. physical, i.e. can be in more than one place at once
    field :virtual, :boolean, default: false

    # i.e. not an individual
    field :group, :boolean, default: false

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :string
    field :batch_note, :string

    field :discarded_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [
      :name,
      :title,
      :first_name,
      :middle_names,
      :last_name,
      :suffix,
      :note,
      :profile
    ])
    |> put_name()
    |> validate_required([:name])
  end

  def discard(obj) do
    change(obj, %{discarded_at: DateTime.utc_now() |> DateTime.truncate(:second)})
  end

  def put_name(changeset) do
    # if first or last name is changed AND name field is not being changed manually, set it automatically
    if !get_change(changeset, :name) &&
         (get_change(changeset, :first_name) || get_change(changeset, :last_name)) do
      first_name = get_field(changeset, :first_name)
      last_name = get_field(changeset, :last_name)
      # FIXME - probably too simplistic
      put_change(changeset, :name, [first_name, last_name] |> Enum.filter(& &1) |> Enum.join(" "))
    else
      changeset
    end
  end
end
