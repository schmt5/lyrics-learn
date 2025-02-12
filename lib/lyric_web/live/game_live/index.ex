defmodule LyricWeb.GameLive.Index do
  use LyricWeb, :live_view

  alias Lyric.Playground
  alias Lyric.Musics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :games, Playground.list_games())}
  end
end
