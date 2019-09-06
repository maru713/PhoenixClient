defmodule Phoenixclient.Repo do
  use Ecto.Repo,
    otp_app: :phoenixclient,
    adapter: Ecto.Adapters.Postgres
end
