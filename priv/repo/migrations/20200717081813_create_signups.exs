defmodule Crew.Repo.Migrations.CreateSignups do
  use Ecto.Migration

  def change do
    create table(:signups, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)
      add :person_id, references(:persons, on_delete: :delete_all, type: :binary_id)
      add :activity_id, references(:activities, on_delete: :delete_all, type: :binary_id)
      add :activity_slot_id, references(:activity_slots, on_delete: :delete_all, type: :binary_id)

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      add :confirmed_at, :utc_datetime
      add :last_reminded_at, :utc_datetime

      timestamps()
    end

    create index(:signups, [:site_id])
    create index(:signups, [:activity_id])
    create index(:signups, [:activity_slot_id])
    create index(:signups, [:person_id])
  end
end
