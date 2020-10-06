defmodule Crew.Repo.Migrations.CreatePersonRels do
  use Ecto.Migration

  def change do
    # graph database lite
    create table(:person_rels, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :src_person_id, references(:persons, on_delete: :delete_all, type: :binary_id)
      add :src_label, :string
      add :dest_person_id, references(:persons, on_delete: :delete_all, type: :binary_id)
      add :dest_label, :string

      add :metadata, :string

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :binary_id
      add :batch_note, :string

      timestamps()
    end

    create index(:person_rels, [:batch_id])
  end
end
