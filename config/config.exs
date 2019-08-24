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
  todays_date: Scrapers.TodaysDate.Date,
  months_to_scrap: 2,
  scrap_on: true,
  scrap_every_n_hours: 24,
  scrapers: [
    Scrapers.LeFerrailleur
  ]

import_config "#{Mix.env()}.exs"
