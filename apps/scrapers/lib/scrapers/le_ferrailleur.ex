defmodule Scrapers.LeFerrailleur do
  @base_url "http://leferrailleur.fr"

  def scrap do
    map_async(months_with_urls(), &scrap_month/1)

    # map_async(
    #   [
    #     %{
    #       date: %{year: 2019, month: 9},
    #       url: "http://leferrailleur.fr/get-month-event/2019-08-01/next"
    #     }
    #   ],
    #   &scrap_month/1
    # )
  end

  defp months_with_urls do
    months = Application.fetch_env!(:scrapers, :months_to_scrap)
    before = Date.utc_today()
    {_, res} = Enum.reduce(0..months, {before, []}, &month_with_url/2)
    res
  end

  defp month_with_url(_, {date, acc}) do
    new_date = month_after(date)

    elt = %{
      date: %{year: date.year, month: date.month},
      url: url_from_date(date)
    }

    {new_date, [elt | acc]}
  end

  defp scrap_month(%{date: date, url: url}) do
    body = HTTPoison.get!(url).body

    Regex.replace(~r/\s+/, body, " ")
    |> Floki.filter_out(".last_month")
    |> Floki.find("a.calendar-item-con")
    |> Enum.map(date_and_url(date))
    |> map_async(&scrap_event/1)
  end

  defp date_and_url(%{year: year, month: month}) do
    fn elt_a ->
      day =
        elt_a
        |> Floki.find(".calendar-item-number")
        |> Floki.text()
        |> String.to_integer()

      case Date.new(year, month, day) do
        {:ok, date} ->
          %{date: date, url: @base_url <> hd(Floki.attribute(elt_a, "href"))}
      end
    end
  end

  def scrap_event(%{date: date, url: url}) do
    %{date: date, url: url}
  end

  defp month_before(date), do: Date.add(date, -Date.days_in_month(date))

  defp month_after(date), do: Date.add(date, Date.days_in_month(date))

  defp url_from_date(date) do
    date = Date.to_iso8601(month_before(date))
    "#{@base_url}/get-month-event/#{date}/next"
  end

  defp map_async(enum, f) do
    enum
    |> Enum.map(&Task.async(fn -> f.(&1) end))
    |> Enum.map(&Task.await/1)
  end
end
