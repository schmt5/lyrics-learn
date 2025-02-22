defmodule LyricWeb.GameLive.Host do
  alias LyricWeb.Endpoint
  use LyricWeb, :live_view

  alias LyricWeb.Presence
  alias Lyric.Playground

  @game_prefix_topic "game_session:"

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    game = Playground.get_game_with_song!(id)
    {:ok, qr_code} = get_qr_code(id)

    if not connected?(socket) do
      {:ok,
       socket
       |> assign(:page_title, "Host Game")
       |> assign(:game, game)
       |> assign(:game_state, :waiting)
       |> assign(:players, [])
       |> assign(:qr_code, qr_code)}
    end

    Presence.subscribe_to_player_activity(id)
    players = Presence.list_players(id)

    {:ok,
     socket
     |> assign(:page_title, "Host Game")
     |> assign(:game, game)
     |> assign(:game_state, :waiting)
     |> assign(:players, players)
     |> assign(:qr_code, qr_code)}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    players = Presence.list_players(to_string(socket.assigns.game.id))

    {:noreply, socket |> assign(:players, players)}
  end

  @impl true
  def handle_info({:broadcast_game_playing, topic}, socket) do
    Endpoint.broadcast(topic, "game_playing", %{
      round: 1,
      options: ["Option 1", "Option 2", "Option 3", "Option 4"],
    })

    {:noreply, assign(socket, :game_state, :playing)}
  end

  @impl true
  def handle_event("start_game", _params, socket) do
    topic = @game_prefix_topic <> to_string(socket.assigns.game.id)
    Endpoint.broadcast(topic, "game_started", %{})

    # Schedule the "game_playing" broadcast after 3000ms (3 seconds)
    Process.send_after(self(), {:broadcast_game_playing, topic}, 3000)

    {:noreply, assign(socket, :game_state, :starting)}
  end

  defp get_qr_code(id) do
    joining_url = LyricWeb.Endpoint.url() <> "/games/#{id}/join"

    joining_url
    |> QRCode.create(:medium)
    |> QRCode.render()
    |> QRCode.to_base64()
  end
end
