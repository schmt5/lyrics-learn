defmodule LyricWeb.GameLive.Host do
  use LyricWeb, :live_view

  alias Lyric.Playground
  alias Lyric.Musics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:page_title, "Host Game")}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    game = Playground.get_game!(id)

    IO.inspect(game)

    {:noreply,
     socket
     |> assign(:game, game)}
  end
end
