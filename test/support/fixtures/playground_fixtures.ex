defmodule Lyric.PlaygroundFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lyric.Playground` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{

      })
      |> Lyric.Playground.create_game()

    game
  end
end
