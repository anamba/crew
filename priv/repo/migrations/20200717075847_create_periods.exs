defmodule Crew.Repo.Migrations.CreatePeriods do
  use Ecto.Migration

  def change do
    create table(:periods, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :slug, :string
      add :description, :string

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      timestamps()
    end

    create index(:periods, [:site_id])
  end
end
