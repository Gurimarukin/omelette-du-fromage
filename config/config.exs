import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

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

# Phoenix

config :pan,
  ecto_repos: [Pan.Repo]

# Configures the endpoint
config :pan, PanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ior2A8wDYyhgwkXLRQY0zzjnDjuM152/3vVere40rkL9tb5794F0afpD4KC1l6GK",
  render_errors: [view: PanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pan.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "PBY76kZ7p0cOR532gCSqd1x6l/j8/nBq"
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
