defmodule PanWeb.ShowView do
  use PanWeb, :view

  import PanWeb.Utils

  alias ShowsStore.Schemas.{Show, Band}

  def venue(%Show{venue: venue}) do
    [venue.name, venue.city]
    |> Enum.filter(&(&1 != nil))
    |> Enum.join(", ")
  end

  def bands(%Show{bands: bands}) do
    bands
    |> Enum.map(& &1.name)
    |> Enum.join(", ")
  end

  def price(%Show{price: price}) do
    case price do
      nil -> "Gratuit"
      p -> Float.to_string(p) <> "€"
    end
  end

  def genres(%Band{genres: genres}) do
    genres
    |> Enum.join(", ")
  end
end
