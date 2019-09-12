defmodule ShowsStore do
  require Ecto.Query

  alias ShowsStore.Repo
  alias ShowsStore.Schemas.{Show, Venue, Band}

  # Shows
  def insert_show(show) do
    show
    |> Show.changeset()
    |> ShowsStore.Repo.insert()
  end

  def get_show(id), do: Repo.get(Show, id)

  def get_show!(id), do: Repo.get!(Show, id)

  def get_show_by(params), do: Repo.get_by(Show, params)

  def list_shows, do: Repo.all(Show)

  def find_venue(%{name: name, zip_code: zip_code}) do
    Venue
    |> Ecto.Query.where(name: ^name)
    |> Ecto.Query.where(zip_code: ^zip_code)
  end

  # Venues
  def get_venue(id), do: Repo.get(Venue, id)

  def get_venue!(id), do: Repo.get!(Venue, id)

  def get_venue_by(params), do: Repo.get_by(Venue, params)

  def list_venues, do: Repo.all(Venue)

  # Bands
  def get_band(id), do: Repo.get(Band, id)

  def get_band!(id), do: Repo.get!(Band, id)

  def get_band_by(params), do: Repo.get_by(Band, params)

  def list_bands, do: Repo.all(Band)
end
