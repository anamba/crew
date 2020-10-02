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

    # 1. primary identifier for a Person not tied to a User
    # 2. for a Person with a User, does not have to be the same email
    # 3. used for notifications (appt reminders, etc.)
    field :email, :string

    # temporarily store new email address here if person wants to change their email address
    field :new_email, :string

    # for generating email TOTP codes
    field :totp_secret_base32, :string

    field :name, :string

    field :title, :string
    field :first_name, :string
    field :middle_names, :string
    field :last_name, :string
    field :suffix, :string

    field :preferred_name, :string
    field :preferred_pronouns, :string

    # if name was imported from a file, store the original version before splitting/processing
    field :original_name, :string

    field :note, :string
    field :profile, :string

    # for custom fields
    field :metadata_json, :string

    # vs. physical, i.e. can be in more than one place at once
    field :virtual, :boolean, default: false

    # i.e. not an individual
    field :group, :boolean, default: false

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :string
    field :batch_note, :string

    field :email_confirmed_at, :utc_datetime
    field :discarded_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [
      :email,
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
    |> put_totp_secret()
    |> validate_required([:name])
  end

  def confirm_email_changeset(person, attrs) do
    person
    |> cast(attrs, [:email])
    |> put_totp_secret()
    |> validate_required([:email])
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

  def put_totp_secret(changeset) do
    if get_field(changeset, :totp_secret_base32) do
      changeset
    else
      secret = NimbleTOTP.secret(10)
      put_change(changeset, :totp_secret_base32, Base.encode32(secret, padding: false))
    end
  end

  # generate codes valid for 30 minutes (but say 20, perhaps)
  @totp_period 1800

  def generate_totp_code(person) do
    {:ok, secret} = Base.decode32(person.totp_secret_base32)
    NimbleTOTP.verification_code(secret, period: @totp_period)
  end

  def verify_totp_code(person, otp) do
    {:ok, secret} = Base.decode32(person.totp_secret_base32)
    NimbleTOTP.valid?(secret, otp, period: @totp_period)
  end
end
