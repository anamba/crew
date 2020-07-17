defmodule Crew.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string
      add :slug, :string
      add :description, :string

      timestamps()
    end
  end
end
