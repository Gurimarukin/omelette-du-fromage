import Config

config :logger, level: :warn

config :shows_store, ShowsStore.Repo,
  database: "shows_store_test",
  username: "elixir",
  password: "elixir",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :scrapers,
  url_getter: Scrapers.Mocks.UrlGetter,
  todays_date: Scrapers.Mocks.TodaysDate,
  scrap_on: false

# Phoenix

# Configure your database
config :pan, Pan.Repo,
  database: "pan_test",
  username: "elixir",
  password: "elixir",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pan, PanWeb.Endpoint,
  http: [port: 4002],
  server: false
