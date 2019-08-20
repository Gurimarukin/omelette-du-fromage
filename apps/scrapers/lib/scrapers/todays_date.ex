defmodule Scrapers.TodaysDate do
  @todays_date Application.get_env(:scrapers, :todays_date)

  @callback get :: Date.t()

  def get(), do: @todays_date.get()
end

defmodule Scrapers.TodaysDate.Date do
  @behaviour Scrapers.TodaysDate

  def get(), do: Date.utc_today()
end
