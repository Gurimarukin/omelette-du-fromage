defmodule ShowsStore.Schemas.Venue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "venues" do
    field(:name, :string)
    field(:website, :string)
    field(:city, :string)
    field(:zip_code, :string)
    has_many(:shows, ShowsStore.Schemas.Show)
  end

  def changeset(venue, params \\ %{}) do
    venue
    |> cast(params, [:name, :website, :city, :zip_code])
    |> validate_required([:name, :city, :zip_code])
    |> unique_constraint(:name, name: :venues_name_zip_code_index)
  end
end
