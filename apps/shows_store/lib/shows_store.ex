defmodule ShowsStore do
  require Ecto.Query

  alias ShowsStore.Schemas.Show
  alias ShowsStore.Schemas.Venue
  alias ShowsStore.Schemas.Band

  def insert_show(show) do
    show
    |> Show.changeset()
    |> ShowsStore.Repo.insert()
  end

  def venue_query(%{name: name, zip_code: zip_code}) do
    Venue
    |> Ecto.Query.where(name: ^name)
    |> Ecto.Query.where(zip_code: ^zip_code)
  end

  def band_query(%{name: name}) do
    Ecto.Query.where(Band, name: ^name)
  end

  def shows() do
    Show
    |> ShowsStore.Repo.all()
    |> ShowsStore.Repo.preload([:venue, :bands])
  end

  def venues() do
    Venue
    |> ShowsStore.Repo.all()
    |> ShowsStore.Repo.preload([:shows])
  end

  def bands() do
    Band
    |> ShowsStore.Repo.all()
    |> ShowsStore.Repo.preload([:shows])
  end
end
