defmodule LyricWeb.GameLive.Play do
  use LyricWeb, :live_view

  alias Lyric.Playground
  alias Lyric.Musics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:page_title, "Play Game")}
  end
end
