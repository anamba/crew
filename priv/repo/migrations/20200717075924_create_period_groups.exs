defmodule Crew.Repo.Migrations.CreatePeriodGroups do
  use Ecto.Migration

  def change do
    create table(:period_groups, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :slug, :string
      add :description, :string

      # enables a number of special features
      add :event, :boolean, default: false, null: false

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :string
      add :batch_note, :string

      timestamps()
    end

    create index(:period_groups, [:site_id])
    create index(:period_groups, [:batch_id])
  end
end
