import Config

config :scrapers,
  url_getter: ScrapersTest.UrlGetter.Mock,
  todays_date: ScrapersTest.TodaysDate.Mock
