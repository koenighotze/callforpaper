# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cfp_ui,
  ecto_repos: [CfpUi.Repo]

# Configures the endpoint
config :cfp_ui, CfpUi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eO0yND09eXXZBztVP23lAyC4ExVaYhOptbDNIEwZeVst/ozlMPlm7OPeqhzzTisp",
  render_errors: [view: CfpUi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CfpUi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
