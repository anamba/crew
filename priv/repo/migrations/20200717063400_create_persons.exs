defmodule Crew.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :title, :string
      add :first_name, :string
      add :middle_names, :string
      add :last_name, :string
      add :suffix, :string

      add :note, :string
      add :profile, :string

      timestamps()
    end
  end
end
