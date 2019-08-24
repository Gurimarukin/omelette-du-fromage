import Config

config :logger, level: :warn

config :scrapers,
  url_getter: Scrapers.Mocks.UrlGetter,
  todays_date: Scrapers.Mocks.TodaysDate,
  scrap_on: false
