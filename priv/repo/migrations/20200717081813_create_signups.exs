defmodule Crew.Repo.Migrations.CreateSignups do
  use Ecto.Migration

  def change do
    create table(:signups, primary_key: false) do
      add :id, :binary_id, primary_key: true

      # FK NOTE: we do not cascade delete signups for any reason other than deleting the entire site
      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      add :time_slot_id, references(:time_slots, type: :binary_id)
      add :guest_id, references(:persons, type: :binary_id)
      add :guest_count, :integer, null: false, default: 1

      add :activity_id, references(:activities, type: :binary_id)
      add :location_id, references(:locations, type: :binary_id)
      add :person_id, references(:persons, type: :binary_id)

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      add :start_time_local, :naive_datetime
      add :end_time_local, :naive_datetime
      add :time_zone, :string

      add :note, :string

      add :confirmed_at, :utc_datetime
      add :last_reminded_at, :utc_datetime

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :binary_id
      add :batch_note, :string

      timestamps()
    end

    create index(:signups, [:batch_id])
  end
end
