defmodule Crew.Repo.Migrations.AddClosedFlag do
  use Ecto.Migration

  def change do
    alter table(:periods) do
      add :closed, :boolean, default: false, null: false
    end
    alter table(:time_slots) do
      add :closed, :boolean, default: false, null: false
    end
    alter table(:activities) do
      add :closed, :boolean, default: false, null: false
    end
    alter table(:sites) do
      add :closed, :boolean, default: false, null: false
    end
  end
end
