# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :shows_store, ShowsStore.Repo,
  database: "shows_store_repo",
  username: "elixir",
  password: "elixir",
  hostname: "localhost"

config :shows_store,
  ecto_repos: [ShowsStore.Repo]
