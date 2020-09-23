defmodule Crew.Repo.Migrations.CreateTimeSlots do
  use Ecto.Migration

  def change do
    create table(:time_slots, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :nothing, type: :binary_id)
      add :period_id, references(:periods, on_delete: :nothing, type: :binary_id)

      # select at least one of these to tie this slot to a particular object
      # (the limiting factor, i.e. the reason we need a scheduling system)
      add :activity_id, references(:activities, on_delete: :delete_all, type: :binary_id)
      add :location_id, references(:locations, on_delete: :delete_all, type: :binary_id)
      add :person_id, references(:persons, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :description, :string

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      add :start_time_local, :naive_datetime
      add :end_time_local, :naive_datetime
      add :time_zone, :string

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :string
      add :batch_note, :string

      timestamps()
    end

    create index(:time_slots, [:site_id])
    create index(:time_slots, [:activity_id])
    create index(:time_slots, [:location_id])
    create index(:time_slots, [:person_id])
    create index(:time_slots, [:batch_id])
  end
end
