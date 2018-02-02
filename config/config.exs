# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :payments,
  ecto_repos: [Payments.Repo]

# Configures the endpoint
config :payments, PaymentsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LLpouBkMMl/Xtp3DH71p53y6XvWKWwroiGExgQ9xwzbke/KtchMGL7irl2EPoHeV",
  render_errors: [view: PaymentsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Payments.PubSub,
           adapter: Phoenix.PubSub.PG2]


# Configure Stripe
config :stripe_post,
   secret_key: System.get_env("STRIPE_SECRET_KEY"),
   public_key: System.get_env("STRIPE_PUBLIC_KEY"),
   content_type: "application/x-www-form-urlencoded"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
