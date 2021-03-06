defmodule Crew.Repo.Migrations.CreatePeriods do
  use Ecto.Migration

  def change do
    create table(:periods, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)
      add :period_group_id, references(:period_groups, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :slug, :string
      add :description, :string

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      add :start_time_local, :naive_datetime
      add :end_time_local, :naive_datetime
      add :time_zone, :string

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :binary_id
      add :batch_note, :string

      timestamps()
    end

    create index(:periods, [:batch_id])
  end
end
