defmodule Crew.Repo.Migrations.PersonsAddAuthToken do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      add :auth_token, :string
    end
  end
end
