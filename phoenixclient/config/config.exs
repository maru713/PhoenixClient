# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phoenixclient,
  ecto_repos: [Phoenixclient.Repo]

# Configures the endpoint
config :phoenixclient, PhoenixclientWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EwHNnHRwiIs+9qf1gQBoptvWWwB8wBbWxNgjV18Pm1ZjWUe+T4gQwKh5P49/49rn",
  render_errors: [view: PhoenixclientWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phoenixclient.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
