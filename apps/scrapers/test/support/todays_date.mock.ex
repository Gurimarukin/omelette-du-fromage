defmodule ScrapersTest.TodaysDate.Mock do
  @behaviour Scrapers.TodaysDate

  def get, do: ~D[2019-08-20]
end
