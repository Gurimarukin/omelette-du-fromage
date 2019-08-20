defmodule Scrapers do
  def get_bodys(urls, name) do
    urls
    |> Enum.map(&RateLimiter.with_limit(name, fn -> get_body(&1) end))
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
    IO.inspect(url, label: "error for url")
    error
  end

  defmodule UrlGetter do
    @url_getter Application.get_env(:scrapers, :url_getter)
                |> IO.inspect(label: "@url_getter")

    @callback get(String.t()) :: {:ok, %{body: term}} | {:error, any}
    # %{
    #   __exception__: term(),
    #   id: reference() | nil,
    #   reason: any()
    # }

    def get(url), do: @url_getter.get(url)
  end

  defmodule HTTPoison do
    @behaviour Scrapers.UrlGetter

    def get(url), do: HTTPoison.get(url)
  end
end
