import Config

config :scrapers,
  url_getter: Scrapers.Mocks.UrlGetter,
  todays_date: Scrapers.Mocks.TodaysDate
