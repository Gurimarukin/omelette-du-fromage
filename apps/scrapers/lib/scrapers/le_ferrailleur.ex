defmodule Scrapers.LeFerrailleur do
  require ShowsStore.Schemas.Venue

  @base_url "http://leferrailleur.fr"
  @venue %ShowsStore.Schemas.Venue{
    name: "Le Ferrailleur",
    website: @base_url,
    city: "Nantes",
    zip_code: "44000"
  }

  def scrap do
    try do
      %{months: months, urls: urls} = months_with_urls()

      urls
      |> Scrapers.get_bodys(__MODULE__)
      |> Enum.zip(months)
      |> Enum.flat_map(&scrap_month/1)
    after
      RateLimitator.stop(__MODULE__)
    end
  end

  defp months_with_urls do
    number_of_months = Application.fetch_env!(:scrapers, :months_to_scrap)
    before = Scrapers.TodaysDate.get()

    {_, res} =
      Enum.reduce(0..(number_of_months - 1), {before, %{months: [], urls: []}}, &month_with_url/2)

    res
  end

  defp month_with_url(_, {date, acc}) do
    new_date = month_after(date)
    new_month = %{year: date.year, month: date.month}
    new_url = url_from_date(date)

    {new_date, %{months: [new_month | acc.months], urls: [new_url | acc.urls]}}
  end

  defp scrap_month({{:ok, body}, date}) do
    parse_month(body, date)
  end

  defp scrap_month({{:error, _}, _}) do
    []
  end

  defp parse_month(body, date) do
    dates_and_urls =
      Regex.replace(~r/\s+/, body, " ")
      |> Floki.filter_out(".last_month")
      |> Floki.find("a.calendar-item-con")
      |> Enum.flat_map(date_and_url(date))

    dates_and_urls
    |> Enum.map(fn {_, url} -> url end)
    |> Scrapers.get_bodys(__MODULE__)
    |> Enum.zip(dates_and_urls)
    |> Enum.flat_map(&scrap_event/1)
  end

  defp date_and_url(%{year: year, month: month}) do
    fn anchor ->
      {
        Date.new(year, month, get_day(anchor)),
        get_href(anchor)
      }
      |> case do
        {{:ok, date}, {:ok, url}} -> [{date, url}]
        _ -> []
      end
    end
  end

  defp get_day(anchor) do
    anchor
    |> Floki.find(".calendar-item-number")
    |> Floki.text()
    |> String.to_integer()
  end

  defp get_href(anchor) do
    path = List.first(Floki.attribute(anchor, "href"))
    if path == nil, do: :error, else: url_if_show(path)
  end

  defp url_if_show(path) do
    if String.starts_with?(path, "/evenement/apero") do
      :error
    else
      {:ok, @base_url <> path}
    end
  end

  defp scrap_event({parse_result, date_and_url}) do
    case parse_result do
      {:ok, body} -> [parse_event(body, date_and_url)]
      _ -> []
    end
  end

  defp parse_event(body, {date, url}) do
    parsed = Regex.replace(~r/\s+/, body, " ") |> Floki.parse()

    %ShowsStore.Schemas.Show{
      date: get_date_time(date, parsed),
      price: get_price(parsed),
      link: url,
      venue: @venue,
      bands: get_bands(parsed)
    }
  end

  defp get_date_time(date, elt) do
    try do
      elt
      |> values_for_label("horaires début")
      |> Floki.text()
      |> String.split(":")
      |> Enum.map(&(&1 |> String.trim() |> String.to_integer()))
      |> build_date_time(date)
    rescue
      _ -> nil
    end
  end

  defp build_date_time([hour, minute], %{year: year, month: month, day: day}) do
    {:ok, naive} = NaiveDateTime.new(year, month, day, hour, minute, 0)
    DateTime.from_naive!(naive, "Etc/UTC")
  end

  defp get_price(elt) do
    elt
    |> values_for_label("prix")
    |> Enum.map(&Floki.text/1)
    |> case do
      [] ->
        nil

      values ->
        values
        |> Enum.flat_map(&parse_euros/1)
        |> Enum.max(fn -> 0.0 end)
    end
  end

  defp parse_euros(value) do
    String.split(value, "€")
    |> case do
      [res, _] -> [res |> String.trim() |> String.to_float()]
      _ -> []
    end
  end

  defp values_for_label(elt, label) do
    elt
    |> Floki.find(".event_con_l_pad > .line")
    |> Enum.find(contains_label(label))
    |> Floki.find(".value")
  end

  defp contains_label(label) do
    fn line ->
      line
      |> Floki.find(".label:fl-contains('#{label}')")
      |> length() > 0
    end
  end

  defp get_bands(elt) do
    elt
    |> Floki.find(".block_band")
    |> Enum.map(&get_band/1)
  end

  defp get_band(elt) do
    %ShowsStore.Schemas.Band{
      name: get_name(elt),
      website: get_website(elt),
      genres: get_genres(elt)
    }
  end

  defp get_name(elt) do
    elt
    |> Floki.find(".block_band_name")
    |> Floki.text()
    |> String.trim()
  end

  defp get_website(elt) do
    elt
    |> Floki.find(".block_band_socials > a")
    |> Floki.attribute("href")
    |> List.first()
    |> case do
      "" -> nil
      res -> res
    end
  end

  defp get_genres(elt) do
    elt
    |> Floki.find(".block_band_genre")
    |> Floki.text()
    |> String.split(",")
    |> Enum.map(&String.trim/1)
  end

  def month_before(date), do: Date.add(date, -Date.days_in_month(date))

  def month_after(date), do: Date.add(date, Date.days_in_month(date))

  defp url_from_date(date) do
    date = Date.to_iso8601(month_before(date))
    "#{@base_url}/get-month-event/#{date}/next"
  end
end
