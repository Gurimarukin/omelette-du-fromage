defmodule ShowsStore.Schemas.Band do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bands" do
    field(:name, :string)
    field(:website, :string)
    field(:country, :string)
    field(:genres, {:array, :string})

    many_to_many(
      :shows,
      ShowsStore.Schemas.Show,
      join_through: "band_show",
      on_replace: :delete
    )
  end

  def changeset(band, params \\ %{}) do
    band
    |> cast(params, [:name, :website, :country, :genres])
    |> validate_required([:name])
    |> unique_constraint(:name)
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
