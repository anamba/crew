defmodule Crew.Repo.Migrations.CreatePersonTags do
  use Ecto.Migration

  def change do
    create table(:person_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :description, :string

      # enable this only on tags that are *not* used for purposes akin to authorization
      add :self_assignable, :boolean, default: false, null: false

      timestamps()
    end

    create index(:person_tags, [:site_id])

    create table(:person_taggings) do
      add :person_id, references(:persons, on_delete: :delete_all, type: :binary_id)
      add :person_tag_id, references(:persons, on_delete: :delete_all, type: :binary_id)
    end

    create index(:person_taggings, [:person_id])
    create index(:person_taggings, [:person_tag_id])
  end
end
