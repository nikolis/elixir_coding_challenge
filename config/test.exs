use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sumup_challenge, SumupChallengeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :sumup_challenge, SumupChallenge.Repo,
  username: "postgres",
  password: "postgres",
  database: "sumup_challenge_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
