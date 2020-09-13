defmodule Crew.Repo.Migrations.CreateActivitySlots do
  use Ecto.Migration

  def change do
    create table(:activity_slots, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :nothing, type: :binary_id)

      # select at least one of these to tie this slot to a particular object
      # (the limiting factor, i.e. the reason we need a scheduling system)
      add :activity_id, references(:activities, on_delete: :delete_all, type: :binary_id)
      add :location_id, references(:locations, on_delete: :delete_all, type: :binary_id)
      add :person_id, references(:persons, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :description, :string

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      timestamps()
    end

    create index(:activity_slots, [:site_id])
    create index(:activity_slots, [:activity_id])
    create index(:activity_slots, [:location_id])
    create index(:activity_slots, [:person_id])
  end
end
