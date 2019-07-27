defmodule ShowsStore.Schema.Band do
  use Ecto.Schema

  schema "bands" do
    field(:name, :string)
    field(:website, :string)
    field(:country, :string)
    field(:genres, {:array, :string})

    many_to_many(
      :shows,
      ShowsStore.Schema.Show,
      join_through: "band_show",
      on_replace: :delete
    )
  end

  def changeset(band, params \\ %{}) do
    band
    |> Ecto.Changeset.cast(params, [:name, :website, :genres])
    |> Ecto.Changeset.validate_required([:name])
  end

  def to_map(band) do
    %{
      name: band.name,
      website: band.website,
      country: band.country,
      genres: band.genres
    }
  end
end
