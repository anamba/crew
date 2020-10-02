defmodule Crew.Repo.Migrations.CreateSignups do
  use Ecto.Migration

  def change do
    create table(:signups, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      add :time_slot_id, references(:time_slots, type: :binary_id)
      add :guest_id, references(:persons, type: :binary_id)

      add :activity_id, references(:activities, type: :binary_id)
      add :location_id, references(:locations, type: :binary_id)
      add :person_id, references(:persons, type: :binary_id)

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      add :note, :string

      add :confirmed_at, :utc_datetime
      add :last_reminded_at, :utc_datetime

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :string
      add :batch_note, :string

      timestamps()
    end

    create index(:signups, [:batch_id])
  end
end
