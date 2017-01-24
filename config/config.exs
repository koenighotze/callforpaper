# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :callforpapers,
  ecto_repos: [Callforpapers.Repo]

# Configures the endpoint
config :callforpapers, Callforpapers.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "v3mzBqw/GzOPG6nb+Qb+uhdRxMcUtPiBg/3xY7/8WksangCuQejI2Bab+L+DU/Ha",
  render_errors: [view: Callforpapers.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Callforpapers.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
