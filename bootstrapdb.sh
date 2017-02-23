#!/bin/sh
docker run --name postgresdb -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=postgres -d -p 5432:5432 postgres:9.6.1-alpine
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
