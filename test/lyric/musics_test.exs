defmodule Lyric.MusicsTest do
  use Lyric.DataCase

  alias Lyric.Musics

  describe "songs" do
    alias Lyric.Musics.Song

    import Lyric.MusicsFixtures

    @invalid_attrs %{title: nil, artist: nil, album: nil}

    test "list_songs/0 returns all songs" do
      song = song_fixture()
      assert Musics.list_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert Musics.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      valid_attrs = %{title: "some title", artist: "some artist", album: "some album"}

      assert {:ok, %Song{} = song} = Musics.create_song(valid_attrs)
      assert song.title == "some title"
      assert song.artist == "some artist"
      assert song.album == "some album"
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Musics.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()
      update_attrs = %{title: "some updated title", artist: "some updated artist", album: "some updated album"}

      assert {:ok, %Song{} = song} = Musics.update_song(song, update_attrs)
      assert song.title == "some updated title"
      assert song.artist == "some updated artist"
      assert song.album == "some updated album"
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Musics.update_song(song, @invalid_attrs)
      assert song == Musics.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Musics.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Musics.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Musics.change_song(song)
    end
  end
end
