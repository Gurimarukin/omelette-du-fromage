defmodule Scrapers do
  require Logger

  def get_bodys(urls, name) do
    urls
    |> Enum.map(&RateLimitator.with_limit(name, fn -> get_body(&1) end))
    |> Enum.map(&Task.await/1)
  end

  defp get_body(url) do
    try do
      Scrapers.UrlGetter.get(url) |> parse_response(url)
    rescue
      e -> {:error, e}
    end
  end

  defp parse_response({:ok, %{body: body}}, _) do
    {:ok, body}
  end

  defp parse_response(error, url) do
    ("error while retrieving url " <> inspect(url))
    |> Logger.info()

    error
  end
end
