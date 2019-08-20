defmodule ScrapersTest.UrlGetter.Mock do
  @behaviour Scrapers.UrlGetter

  def get(url) do
    case url do
      "toto" -> {:ok, %{body: :toto}}
      _ -> {:error, :not_found}
    end
  end
end
