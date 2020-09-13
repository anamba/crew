defmodule Crew.Repo.Migrations.CreateActivitySlotRequirements do
  use Ecto.Migration

  def change do
    create table(:activity_slot_requirements, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :activity_slot_id, references(:activity_slots, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :description, :string

      # use to group requirements that should be OR'd (otherwise they are AND'ed)
      add :option_group, :integer

      # these references are all optional and add a requirement for signups on this activity slot
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

      timestamps()
    end

    create index(:activity_slot_requirements, [:activity_slot_id])
    create index(:activity_slot_requirements, [:activity_tag_id])
    create index(:activity_slot_requirements, [:person_tag_id])
  end
end
