defmodule ShowsStore.Venue do
  use Ecto.Schema

  schema "venues" do
    field(:name, :string)
    field(:website, :string)
  end

  def changeset(venue, params \\ %{}) do
    venue
    |> Ecto.Changeset.cast(params, [:name, :website])
    |> Ecto.Changeset.validate_required([:name])
  end
end
