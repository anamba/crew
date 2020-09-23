defmodule Crew.Repo.Migrations.CreateTimeSlotRequirements do
  use Ecto.Migration

  def change do
    create table(:time_slot_requirements, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :time_slot_id, references(:time_slots, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :description, :string

      # use to group requirements that should be OR'd (otherwise they are AND'ed)
      add :option_group, :integer

      # these references are all optional and add a requirement for signups on this Time Slot
      add :activity_tag_id, references(:activity_tags, on_delete: :delete_all, type: :binary_id)
      add :person_tag_id, references(:person_tags, on_delete: :delete_all, type: :binary_id)
      add :person_tag_value, :string
      add :person_tag_value_i, :integer

      add :person_gap_before_minutes, :integer
      add :person_gap_after_minutes, :integer
      add :location_gap_before_minutes, :integer
      add :location_gap_after_minutes, :integer

      add :start_time, :time
      add :end_time, :time

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :string
      add :batch_note, :string

      timestamps()
    end

    create index(:time_slot_requirements, [:time_slot_id])
    create index(:time_slot_requirements, [:activity_tag_id])
    create index(:time_slot_requirements, [:person_tag_id])
    create index(:time_slot_requirements, [:batch_id])
  end
end
