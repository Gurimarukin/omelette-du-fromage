defmodule ShowsStore.Repo.Migrations.CreateShows do
  use Ecto.Migration

  def change do
    # Shows
    create table(:shows) do
      add(:date, :utc_datetime, null: false)
      add(:price, :float)
      add(:link, :string)
      add(:venue_id, :id, null: false)
      timestamps()
    end

    create(unique_index(:shows, [:date, :venue_id]))

    # Venues
    create table(:venues) do
      add(:name, :string, null: false)
      add(:website, :string)
      add(:city, :string, null: false)
      add(:zip_code, :string, null: false)
    end

    create(unique_index(:venues, [:name, :zip_code]))

    # Bands
    create table(:bands) do
      add(:name, :string, null: false)
      add(:website, :string)
      add(:country, :string)
      add(:genres, {:array, :string})
    end

    create(unique_index(:bands, [:name]))

    # Bands - Shows
    create table(:band_show, primary_key: false) do
      add(:show_id, references(:shows, on_delete: :delete_all), primary_key: true)
      add(:band_id, references(:bands, on_delete: :delete_all), primary_key: true)
    end

    create(index(:band_show, [:show_id]))
    create(index(:band_show, [:band_id]))

    create(unique_index(:band_show, [:band_id, :show_id], name: :band_id_show_id_unique_index))
  end
end
