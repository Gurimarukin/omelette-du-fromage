defmodule Scrapers.CronJob do
  use GenServer

  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(state) do
    work()
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    work()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    hours = Application.fetch_env!(:scrapers, :scrap_every_n_hours)
    Process.send_after(self(), :work, hours * 60 * 60 * 1000)
  end

  defp work do
    if Application.fetch_env!(:scrapers, :scrap_on) do
      Logger.info("start scraping")

      Application.fetch_env!(:scrapers, :scrapers)
      |> Enum.map(&Task.start_link(fn -> try_scrap(&1) end))
    end
  end

  defp try_scrap(scraper) do
    try do
      scrap(scraper)
    rescue
      e -> recover(scraper, e)
    end
  end

  defp recover(scraper, e) do
    [inspect(scraper), inspect(e)]
    |> Enum.join(": ")
    |> Logger.error()
  end

  defp scrap(scraper) do
    Logger.info("scraping " <> inspect(scraper))
    scraper.scrap |> Enum.map(&ShowsStore.insert_show/1)
  end
end
