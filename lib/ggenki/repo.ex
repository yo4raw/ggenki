defmodule Ggenki.Repo do
  use Ecto.Repo,
    otp_app: :ggenki,
    adapter: Ecto.Adapters.Postgres
end
