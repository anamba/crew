defmodule Crew.Repo.Migrations.CreateActivitySlots do
  use Ecto.Migration

  def change do
    create table(:activity_slots, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :nothing, type: :binary_id)

      add :name, :string
      add :description, :string

      timestamps()
    end

    create index(:activity_slots, [:site_id])
  end
end
