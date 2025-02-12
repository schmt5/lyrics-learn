defmodule Lyric.Musics.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :title, :string
    field :artist, :string
    field :album, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:title, :artist, :album])
    |> validate_required([:title, :artist, :album])
  end
end
