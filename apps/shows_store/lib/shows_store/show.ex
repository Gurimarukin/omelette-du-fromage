defmodule ShowsStore.Show do
  use Ecto.Schema

  alias ShowsStore.Venue, as: Venue
  alias ShowsStore.Band, as: Band

  schema "shows" do
    field(:date, :utc_datetime)
    field(:price, :float)
    field(:link, :string)
    has_one(:venue, Venue, foreign_key: :id)
    has_many(:bands, Band, foreign_key: :id)
  end

  def changeset(show, params \\ %{}) do
    show
    |> Ecto.Changeset.cast(params, [:date, :price, :link])
    |> Ecto.Changeset.validate_required([:date, :venue])
  end
end

DateTime.utc_now()
