# Omelette du Fromage

Concert dates aggregator.

## Development

Start the PostgreSQL container:

    docker-compose up

Connect to it:

    psql -h localhost -U elixir shows_store_repo # password: elixir

Run the migrations:

    mix ecto.migrate

Fixtures generation:

    ShowsStore.Fixtures.gen
