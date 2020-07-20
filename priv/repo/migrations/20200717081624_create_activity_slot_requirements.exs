defmodule Crew.Repo.Migrations.CreateActivitySlotRequirements do
  use Ecto.Migration

  def change do
    create table(:activity_slot_requirements, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)
      add :activity_slot_id, references(:activity_slots, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :description, :string

      # use to group together requirements that should be OR'd (otherwise they are AND'ed)
      add :option_group, :integer

      # these references are all optional and add a requirement for signups on this activity slot
      add :activity_id, references(:activities, on_delete: :delete_all, type: :binary_id)
      add :location_id, references(:locations, on_delete: :delete_all, type: :binary_id)
      add :person_id, references(:persons, on_delete: :delete_all, type: :binary_id)

      add :person_gap_before_minutes, :integer
      add :person_gap_after_minutes, :integer
      add :location_gap_before_minutes, :integer
      add :location_gap_after_minutes, :integer

      add :start_time, :time
      add :end_time, :time

      timestamps()
    end

    create index(:activity_slot_requirements, [:site_id])
    create index(:activity_slot_requirements, [:activity_id])
    create index(:activity_slot_requirements, [:person_id])
    create index(:activity_slot_requirements, [:location_id])
  end
end
