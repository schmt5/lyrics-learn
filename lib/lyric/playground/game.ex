defmodule Lyric.Playground.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :song, Lyric.Musics.Song

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:song_id])
    |> validate_required([:song_id])
  end
end
