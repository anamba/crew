defmodule Crew.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, type: :binary_id, on_delete: :delete_all), null: false
      add :location_id, references(:locations, type: :binary_id, on_delete: :nothing)

      # 1. primary identifier for a Person not tied to a User
      # 2. for a Person with a User, does not have to be the same email
      # 3. used for notifications (appt reminders, etc.)
      add :email, :string

      # temporarily store new (unconfirmed) email address here if person wants to change their email address
      add :new_email, :string

      # for generating email TOTP codes
      add :totp_secret_base32, :string

      add :name, :string, null: false, default: ""

      add :title, :string
      add :first_name, :string
      add :middle_names, :string
      add :last_name, :string
      add :suffix, :string

      add :preferred_name, :string
      add :preferred_pronouns, :string

      add :time_zone, :string

      # the way we got the name in the file
      add :original_name, :string

      # for custom fields
      add :metadata_json, :string

      add :note, :string
      add :profile, :string

      # vs. physical, i.e. can be in more than one place at once
      add :virtual, :boolean, default: false, null: false

      # i.e. not an individual
      add :group, :boolean, default: false, null: false

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :binary_id
      add :batch_note, :string

      add :email_confirmed_at, :utc_datetime
      add :discarded_at, :utc_datetime

      timestamps()
    end

    create index(:persons, [:batch_id])
  end
end
