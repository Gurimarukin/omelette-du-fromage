defmodule ShowsStore.Repo.Migrations.CreateShows do
  use Ecto.Migration

  def change do
    create table(:shows) do
      add(:date, :utc_datetime)
      add(:price, :float)
      add(:link, :string)
    end

    create table(:venues) do
      add(:name, :string)
      add(:website, :string)
    end

    create table(:bands) do
      add(:name, :string)
      add(:website, :string)
      add(:genres, {:array, :string})
    end
  end
end
