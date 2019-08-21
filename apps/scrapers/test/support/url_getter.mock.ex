defmodule ScrapersTest.UrlGetter.Mock do
  @behaviour Scrapers.UrlGetter

  def get(url) do
    case url do
      "toto" ->
        {:ok, %{body: :toto}}

      "http://leferrailleur.fr/get-month-event/2019-08-21/next" ->
        {:ok, %{body: LeFerrailleurTest.Next20190821Html.get()}}

      "http://leferrailleur.fr/get-month-event/2019-07-20/next" ->
        {:ok, %{body: LeFerrailleurTest.Next20190720Html.get()}}

      "http://leferrailleur.fr/evenement/walls-of-jericho-stinky/3166" ->
        {:ok, %{body: LeFerrailleurTest.WallsOfJerichoStinkyHtml.get()}}

      "http://leferrailleur.fr/evenement/catfish/3281" ->
        {:ok, %{body: ""}}

      "http://leferrailleur.fr/evenement/fete-du-slip-2/3276" ->
        {:ok, %{body: LeFerrailleurTest.FeteDuSlip2Html.get()}}

      _ ->
        {:error, :not_found}
    end
  end
end
