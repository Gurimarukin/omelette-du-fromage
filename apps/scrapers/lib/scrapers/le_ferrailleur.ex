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
    map_async(months_with_urls(), &scrap_month/1)
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
    Regex.replace(~r/\s+/, HTTPoison.get!(url).body, " ")
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
    parsed =
      Regex.replace(~r/\s+/, HTTPoison.get!(url).body, " ")
      |> Floki.parse()

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
    values =
      elt
      |> values_for_label("prix")
      |> Enum.map(&Floki.text/1)

    if Enum.any?(values, &String.contains?(&1, "€")) do
      values
      |> Enum.flat_map(&parse_euros/1)
      |> Enum.max(fn -> 0.0 end)
    else
      0.0
    end
  end

  defp parse_euros(value) do
    case String.split(value, "€") do
      [_] -> []
      [res, _] -> [res |> String.trim() |> String.to_float()]
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
    case elt
         |> Floki.find(".block_band_socials > a")
         |> Floki.attribute("href")
         |> List.first() do
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
