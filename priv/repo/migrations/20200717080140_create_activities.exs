defmodule Crew.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :slug, :string
      add :description, :string

      add :min_duration_minutes, :integer, default: 25
      add :max_duration_minutes, :integer, default: 25
      add :duration_increment_minutes, :integer, default: 15

      add :template, :boolean, default: false

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :string
      add :batch_note, :string

      timestamps()
    end

    create index(:activities, [:site_id])
    create index(:activities, [:batch_id])
  end
end
