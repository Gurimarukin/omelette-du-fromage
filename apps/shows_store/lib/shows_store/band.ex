defmodule ShowsStore.Band do
  use Ecto.Schema

  schema "bands" do
    field(:name, :string)
    field(:website, :string)
    field(:genres, {:array, :string})
  end

  def changeset(band, params \\ %{}) do
    band
    |> Ecto.Changeset.cast(params, [:name, :website, :genres])
    |> Ecto.Changeset.validate_required([:name])
  end
end
