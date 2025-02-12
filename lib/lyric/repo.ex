defmodule Lyric.Repo do
  use Ecto.Repo,
    otp_app: :lyric,
    adapter: Ecto.Adapters.SQLite3
end
