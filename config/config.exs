# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todo_tutorial,
  ecto_repos: [TodoTutorial.Repo]

# Configures the endpoint
config :todo_tutorial, TodoTutorialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z7jx2Q9ybvsmEOHbH4AV31WvgH2xc1uhq7xofgUqcjfkgFcojMcHLZvjmB59aZdn",
  render_errors: [view: TodoTutorialWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TodoTutorial.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "BcLk5bnRgve6ybmQi8CASRQ0zFtn/NXa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
