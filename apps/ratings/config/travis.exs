use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ratings, Ratings.Endpoint,
  http: [port: 4021],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ratings, Ratings.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "ratings_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
