defmodule ShowsStore.Repo do
  use Ecto.Repo,
    otp_app: :shows_store,
    adapter: Ecto.Adapters.Postgres
end
