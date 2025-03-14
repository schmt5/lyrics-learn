defmodule Lyric.Musics.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :title, :string
    field :artist, :string
    field :album, :string
    field :lyrics, :map

    has_many :games, Lyric.Playground.Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:title, :artist, :album, :lyrics])
    |> validate_required([:title, :artist, :album])
  end
end
