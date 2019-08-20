defmodule Scrapers.UrlGetter do
  @url_getter Application.get_env(:scrapers, :url_getter)

  @callback get(String.t()) :: {:ok, %{body: term}} | {:error, any}

  def get(url), do: @url_getter.get(url)
end

defmodule Scrapers.UrlGetter.HTTPoison do
  @behaviour Scrapers.UrlGetter

  def get(url), do: HTTPoison.get(url)
end
