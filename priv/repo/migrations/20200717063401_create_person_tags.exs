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

      # for self-assignable tags, optionally allow user to enter a custom value
      # can be a string value (free text or select, e.g. T-Shirt Size)
      add :has_value, :boolean, default: false, null: false
      add :value_choices_json, :string
      # or an integer (e.g. grad year, number of guests)
      add :has_value_i, :boolean, default: false, null: false
      add :value_i_min, :integer
      add :value_i_max, :integer

      timestamps()
    end

    create index(:person_tags, [:site_id])

    create table(:person_taggings) do
      add :person_id, references(:persons, on_delete: :delete_all, type: :binary_id)
      add :person_tag_id, references(:persons, on_delete: :delete_all, type: :binary_id)

      add :value, :string
      add :value_i, :integer
    end

    create index(:person_taggings, [:person_id])
    create index(:person_taggings, [:person_tag_id, :value])
    create index(:person_taggings, [:person_tag_id, :value_i])
  end
end
