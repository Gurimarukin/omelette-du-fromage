import Config

config :shows_store, ShowsStore.Repo,
  database: "shows_store_repo",
  username: "elixir",
  password: "elixir",
  hostname: "localhost"

config :shows_store,
  ecto_repos: [ShowsStore.Repo]

config :scrapers,
  url_getter: Scrapers.UrlGetter.HTTPoison,
  months_to_scrap: 2

import_config "#{Mix.env()}.exs"
