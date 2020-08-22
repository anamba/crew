defmodule Crew.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, type: :binary_id, on_delete: :delete_all), null: false

      add :title, :string
      add :first_name, :string
      add :middle_names, :string
      add :last_name, :string
      add :suffix, :string

      add :preferred_name, :string
      add :preferred_pronouns, :string

      # for custom fields
      add :metadata_json, :string

      add :note, :string
      add :profile, :string

      add :notification_email, :string

      # vs. physical, i.e. can be in more than one place at once
      add :virtual, :boolean, default: false, null: false

      # i.e. not an individual
      add :group, :boolean, default: false, null: false

      add :batch_uuid, :string

      timestamps()
    end

    create index(:persons, [:site_id])
    create index(:persons, [:batch_uuid])
  end
end
