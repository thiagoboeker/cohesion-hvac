defmodule HVACDatabase.Repo do
  use Ecto.Repo,
    otp_app: :hvac_database,
    adapter: Ecto.Adapters.Postgres
end
