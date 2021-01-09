defmodule Crew.Repo.Migrations.PersonsAddEmailPermissionFields do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      add :email_opted_in_at, :naive_datetime
      add :email_opted_out_at, :naive_datetime
    end
  end
end
