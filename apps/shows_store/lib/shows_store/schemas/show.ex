defmodule ShowsStore.Schema.Show do
  use Ecto.Schema

  import Ecto.Query

  alias ShowsStore.Schema.Band
  alias ShowsStore.Schema.Venue

  schema "shows" do
    field(:date, :utc_datetime)
    field(:price, :float)
    field(:link, :string)
    belongs_to(:venue, ShowsStore.Schema.Venue, on_replace: :nilify)

    many_to_many(
      :bands,
      ShowsStore.Schema.Band,
      join_through: "band_show",
      on_replace: :delete
    )

    timestamps()
  end

  def changeset(show, params \\ %{}) do
    {_, without_bands} = Map.pop(show, :bands)

    without_bands
    |> Ecto.Changeset.cast(params, [:date, :price, :link])
    |> Ecto.Changeset.validate_required([:date, :venue])
    |> Ecto.Changeset.put_assoc(:venue, lookup_venue(show.venue))
    |> Ecto.Changeset.put_assoc(:bands, get_or_insert_bands(show.bands))
  end

  defp lookup_venue(venue) do
    ShowsStore.venue_query(venue)
    |> ShowsStore.Repo.one()
    |> case do
      nil -> Venue.changeset(venue)
      existing -> existing
    end
  end

  defp get_or_insert_bands([]) do
    []
  end

  defp get_or_insert_bands(bands) do
    bands = Enum.map(bands, &Band.to_map/1)
    names = Enum.map(bands, & &1.name)

    ShowsStore.Repo.insert_all(Band, bands, on_conflict: :nothing)
    ShowsStore.Repo.all(from(t in Band, where: t.name in ^names))
  end
end
