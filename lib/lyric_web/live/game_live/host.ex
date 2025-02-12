defmodule LyricWeb.GameLive.Host do
  use LyricWeb, :live_view

  alias Lyric.Playground
  alias Lyric.Musics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:page_title, "Host Game") |> assign(:qr_code, "")}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    game = Playground.get_game_with_song!(id)
    {:ok, qr_code} = get_qr_code(id)

    IO.inspect(game)

    {:noreply,
     socket
     |> assign(:game, game)
     |> assign(:qr_code, qr_code)}
  end

  defp get_qr_code(id) do
    joining_url = LyricWeb.Endpoint.url() <> "/games/#{id}/play"

    joining_url
    |> QRCode.create(:medium)
    |> QRCode.render()
    |> QRCode.to_base64()
  end
end
