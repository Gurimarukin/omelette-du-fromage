defmodule ScrapersTest.UrlGetter.Mock do
  @behaviour Scrapers.UrlGetter

  def get(url) do
    case url do
      "toto" ->
        {:ok, %{body: :toto}}

      "http://leferrailleur.fr/get-month-event/2019-08-21/next" ->
        {:ok, %{body: File.read!("test/support/le_ferrailleur/2019-08-21.next.html")}}

      "http://leferrailleur.fr/get-month-event/2019-07-20/next" ->
        {:ok, %{body: File.read!("test/support/le_ferrailleur/2019-07-20.next.html")}}

      "http://leferrailleur.fr/evenement/walls-of-jericho-stinky/3166" ->
        {:ok, %{body: File.read!("test/support/le_ferrailleur/walls-of-jericho-stinky.html")}}

      "http://leferrailleur.fr/evenement/catfish/3281" ->
        {:ok, %{body: ""}}

      "http://leferrailleur.fr/evenement/fete-du-slip-2/3276" ->
        {:ok, %{body: File.read!("test/support/le_ferrailleur/fete-du-slip-2.html")}}

      _ ->
        {:error, :not_found}
    end
  end
end
