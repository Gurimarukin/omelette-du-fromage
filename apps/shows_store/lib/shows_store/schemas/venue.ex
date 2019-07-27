defmodule ShowsStore.Schema.Venue do
  use Ecto.Schema

  schema "venues" do
    field(:name, :string)
    field(:website, :string)
    field(:city, :string)
    field(:zip_code, :string)
    has_many(:shows, ShowsStore.Schema.Show)
  end

  def changeset(venue, params \\ %{}) do
    venue
    |> Ecto.Changeset.cast(params, [:name, :website, :city, :zip_code])
    |> Ecto.Changeset.validate_required([:name, :city, :zip_code])
  end
end
