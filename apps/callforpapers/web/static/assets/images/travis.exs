use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conference, CfpUi.Endpoint,
  http: [port: 4011],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :conference, CfpUi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "conference_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
