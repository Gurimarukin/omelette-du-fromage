defmodule PanWeb.ShowController do
  use PanWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias ShowsStore.Schemas.{Band, Venue}

  def index(conn, _opts) do
    query_venue = from(v in Venue, select: %Venue{name: v.name, city: v.city})
    query_bands = from(b in Band, select: %Band{name: b.name})

    shows =
      ShowsStore.list_shows()
      |> ShowsStore.Repo.preload(
        venue: query_venue,
        bands: query_bands
      )

    render(conn, "index.html", shows: shows)
  end

  def show(conn, %{"id" => id}) do
    query_venue = from(v in Venue, select: %Venue{id: v.id, name: v.name, city: v.city})
    query_bands = from(b in Band, select: %Band{id: b.id, name: b.name, genres: b.genres})

    show =
      ShowsStore.get_show(id)
      |> ShowsStore.Repo.preload(
        venue: query_venue,
        bands: query_bands
      )

    render(conn, "show.html", show: show)
  end
end
