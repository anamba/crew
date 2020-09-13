defmodule Crew.Repo.Migrations.CreateSiteMembers do
  use Ecto.Migration

  def change do
    create table(:site_members, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, type: :binary_id, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      add :person_id, references(:persons, type: :binary_id, on_delete: :delete_all)

      add :role, :string

      add :discarded_at, :utc_datetime

      timestamps()
    end
  end
end
