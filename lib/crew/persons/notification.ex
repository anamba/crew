defmodule Crew.Persons.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Persons.Person

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "person_notifications" do
    belongs_to :person, Person

    field :subject, :string
    field :body, :string

    field :notification_type, :string

    # if the keys match, but the quantities are opposite,
    # they cancel out and are skipped (no notification sent)
    field :action_key, :string
    field :action_quantity, :integer

    field :via_web, :boolean, default: false
    field :via_email, :boolean, default: false
    field :via_sms, :boolean, default: false
    field :priority, :integer

    field :seen_at, :utc_datetime
    field :sent_at, :utc_datetime
    field :skipped_at, :utc_datetime

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :binary_id
    field :batch_note, :string

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [
      :person_id,
      :subject,
      :body,
      :action_key,
      :action_quantity,
      :notification_type,
      :via_web,
      :via_email,
      :via_sms,
      :priority
    ])
    |> validate_required([
      :body
    ])
  end

  def timestamp_changeset(notification, attrs) do
    notification
    |> cast(attrs, [:seen_at, :sent_at, :skipped_at])
  end
end
