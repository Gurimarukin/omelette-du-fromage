# Omelette du Fromage

Concert dates aggregator.

## Development

Start the PostgreSQL container:

    docker-compose up

Run the migrations:

    mix ecto.migrate

Fixtures generation:

    ShowsStore.Fixtures.gen
