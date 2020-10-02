defmodule Crew.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      add :name, :string
      add :slug, :string
      add :description, :string

      add :longitude, :decimal
      add :latitude, :decimal
      add :time_zone, :string

      add :capacity, :integer
      add :target_capacity, :integer

      add :address1, :string
      add :address2, :string
      add :address3, :string
      add :city, :string
      add :state, :string
      add :postal_code, :string
      add :country, :string

      # to allow mass-created records to be edited/deleted together as well
      add :batch_id, :string
      add :batch_note, :string

      timestamps()
    end

    create index(:locations, [:batch_id])
  end
end
