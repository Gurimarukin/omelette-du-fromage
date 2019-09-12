defmodule PanWeb.VenueController do
  use PanWeb, :controller

  # import Ecto.Query, only: [from: 2]

  # alias ShowsStore.Schemas.{Venue}

  def index(conn, _opts) do
    # query_venue = from(v in Venue, select: %Venue{name: v.name, city: v.city})
    # query_bands = from(b in Band, select: %Band{name: b.name})

    venues = ShowsStore.list_venues()
    # |> ShowsStore.Repo.preload(
    #   venue: query_venue,
    #   venues: query_venues
    # )

    render(conn, "index.html", venues: venues)
  end

  def show(conn, %{"id" => id}) do
    # query_venue = from(v in Venue, select: %Venue{id: v.id, name: v.name, city: v.city})

    venue = ShowsStore.get_venue(id)
    # |> ShowsStore.Repo.preload(
    #   venue: query_venue,
    #   bands: query_bands
    # )

    render(conn, "show.html", venue: venue)
  end
end
