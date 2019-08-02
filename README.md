# Omelette du Fromage

Concert dates aggregator.

## Development

Start the PostgreSQL container:

    docker-compose up

If you want to connect to it:

    psql -h localhost -U elixir shows_store_repo # password: elixir

Remove the container:

    docker rm odf-postgresql
