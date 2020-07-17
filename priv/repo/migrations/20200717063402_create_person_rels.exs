defmodule Crew.Repo.Migrations.CreatePersonRels do
  use Ecto.Migration

  def change do
    # graph database lite
    create table(:person_rels, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :src_person_id, references(:persons, on_delete: :delete_all, type: :binary_id)
      add :verb, :string
      add :dest_person_id, references(:persons, on_delete: :delete_all, type: :binary_id)

      add :metadata, :string

      timestamps()
    end

    create index(:person_rels, [:src_person_id])
    create index(:person_rels, [:dest_person_id])
  end
end
