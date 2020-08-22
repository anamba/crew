defmodule Crew.Repo.Migrations.CreateActivityTags do
  use Ecto.Migration

  def change do
    create table(:activity_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :nothing, type: :binary_id)

      add :name, :string
      add :description, :string

      timestamps()
    end

    create index(:activity_tags, [:site_id])

    create table(:activity_taggings) do
      add :activity_id, references(:activities, on_delete: :nothing, type: :binary_id)
      add :activity_tag_id, references(:activity_tags, on_delete: :nothing, type: :binary_id)
    end

    create index(:activity_taggings, [:activity_id])
    create index(:activity_taggings, [:activity_tag_id])
  end
end
