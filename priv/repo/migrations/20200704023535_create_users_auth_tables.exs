defmodule Crew.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string
      add :email, :string, null: false, size: 160
      add :hashed_password, :string, null: false, default: ""

      add :admin, :boolean, default: false
      add :confirmed_at, :utc_datetime

      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      add :token, :binary, null: false, size: 32
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(updated_at: false)
    end

    create unique_index(:users_tokens, [:context, :token])
  end
end
