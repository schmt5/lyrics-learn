defmodule Lyric.MusicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lyric.Musics` context.
  """

  @doc """
  Generate a song.
  """
  def song_fixture(attrs \\ %{}) do
    {:ok, song} =
      attrs
      |> Enum.into(%{
        album: "some album",
        artist: "some artist",
        title: "some title"
      })
      |> Lyric.Musics.create_song()

    song
  end
end
