defmodule Crew.Repo.Migrations.PersonsAddSearchIndex do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      add :search_index, :text
    end
    execute "CREATE FULLTEXT INDEX fulltext_index_persons_search_index ON persons(search_index)"
  end
end
