defmodule Lyric.PlaygroundTest do
  use Lyric.DataCase

  alias Lyric.Playground

  describe "games" do
    alias Lyric.Playground.Game

    import Lyric.PlaygroundFixtures

    @invalid_attrs %{}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Playground.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Playground.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{}

      assert {:ok, %Game{} = game} = Playground.create_game(valid_attrs)
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Playground.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{}

      assert {:ok, %Game{} = game} = Playground.update_game(game, update_attrs)
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Playground.update_game(game, @invalid_attrs)
      assert game == Playground.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Playground.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Playground.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Playground.change_game(game)
    end
  end
end
