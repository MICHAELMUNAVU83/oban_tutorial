defmodule ObanTutorial.Repo do
  use Ecto.Repo,
    otp_app: :oban_tutorial,
    adapter: Ecto.Adapters.Postgres
end
