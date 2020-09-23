defmodule Crew.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string
      add :slug, :string, unique: true, null: false
      add :description, :string
      add :primary_domain, :string

      add :default_time_zone, :string

      add :discarded_at, :utc_datetime

      timestamps()
    end
  end
end
