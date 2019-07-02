defmodule SumupChallenge.Repo do
  use Ecto.Repo,
    otp_app: :sumup_challenge,
    adapter: Ecto.Adapters.Postgres
end
