defmodule Crew.Repo.Migrations.CreateActivityTags do
  use Ecto.Migration

  def change do
    create table(:activity_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :nothing, type: :binary_id)

      add :name, :string
      add :description, :string

      # disable to allow public to use for filtering
      add :internal_use_only, :boolean, default: true, null: false

      timestamps()
    end

    create index(:activity_tags, [:site_id])

    create table(:activity_taggings) do
      add :activity_id, references(:activities, on_delete: :nothing, type: :binary_id)
      add :activity_tag_id, references(:activity_tags, on_delete: :nothing, type: :binary_id)

      # denormalize name to avoid another join to activity_tags
      add :name, :string

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :binary_id
      add :batch_note, :string
    end

    create index(:activity_taggings, [:batch_id])
  end
end
