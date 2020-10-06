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

      # these references are all optional and add a requirement for signups on this Time Slot
      add :activity_tag_id, references(:activity_tags, on_delete: :delete_all, type: :binary_id)
      add :person_tag_id, references(:person_tags, on_delete: :delete_all, type: :binary_id)
      add :person_tag_value, :string
      add :person_tag_value_i, :integer

      add :person_gap_before_minutes, :integer
      add :person_gap_after_minutes, :integer
      add :location_gap_before_minutes, :integer
      add :location_gap_after_minutes, :integer

      add :name, :string
      add :description, :string

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      add :start_time_local, :naive_datetime
      add :end_time_local, :naive_datetime
      add :time_zone, :string

      # these limit/allow/encourage overbooking
      # for scheduling an appointment, it should be target = 1
      # for scheduling a class, fair shift, etc. there can be a range of values
      add :signup_target, :integer, null: false, default: 1

      # if false, each signup will take up the entire time slot
      add :allow_division, :boolean, null: false, default: true

      # if signup_target > 1 and allow_division = false, maximum sets a cap
      # signups_available is a cached calculation of how many more people can sign up
      add :signup_maximum, :integer
      add :signups_available, :integer

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :binary_id
      add :batch_note, :string

      timestamps()
    end

    create index(:time_slots, [:batch_id])
  end
end
