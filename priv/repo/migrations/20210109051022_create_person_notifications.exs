defmodule Crew.Repo.Migrations.CreatePersonNotifications do
  use Ecto.Migration

  def change do
    create table(:person_notifications, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :person_id, references(:persons, on_delete: :nothing, type: :binary_id)

      add :subject, :string
      add :body, :text

      add :notification_type, :string

      # if the keys match, but the quantities are opposite,
      # they cancel out and are skipped (no notification sent)
      add :action_key, :string
      add :action_quantity, :integer

      add :via_web, :boolean, default: true, null: false
      add :via_email, :boolean, default: true, null: false
      add :via_sms, :boolean, default: false, null: false
      add :priority, :integer

      add :sent_at, :naive_datetime
      add :seen_at, :naive_datetime
      add :skipped_at, :naive_datetime

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :binary_id
      add :batch_note, :string

      timestamps()
    end

    create index(:person_notifications, [:person_id])
  end
end
