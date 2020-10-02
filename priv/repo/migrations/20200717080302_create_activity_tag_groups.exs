defmodule Crew.Repo.Migrations.CreateActivityTagGroups do
  use Ecto.Migration

  def change do
    create table(:activity_tag_groups, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
