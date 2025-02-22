defmodule LyricWeb.GameLive.Play do
  use LyricWeb, :live_view

  alias LyricWeb.Presence
  alias LyricWeb.Endpoint

  @game_prefix_topic "game_session:"

  @impl true
  def mount(params, _session, socket) do
    game_id = Map.get(params, "id")
    player_name = Map.get(params, "player_name")

    {:ok,
     socket
     |> assign(:page_title, "Spielen")
     |> assign(:game_id, game_id)
     |> assign(:player_name, player_name)
     |> assign(:status, :waiting)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    maybe_join_game(socket)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "game_started"}, socket) do
    {:noreply, assign(socket, :status, :playing)}
  end

  defp maybe_join_game(socket) do
    if connected?(socket) do
      game_topic = @game_prefix_topic <> to_string(socket.assigns.game_id)
      player_name = socket.assigns.player_name

      Presence.track_player(self(), socket.assigns.game_id, player_name)
      Endpoint.subscribe(game_topic)
    end
  end
end
