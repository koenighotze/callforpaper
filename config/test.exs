use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :callforpapers, Callforpapers.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :warn
  # compile_time_purge_level: :debug

# Configure your database
config :callforpapers, Callforpapers.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "secret",
  database: "callforpapers_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
