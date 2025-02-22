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
     |> assign(:status, :waiting)
     |> assign(:round, nil)
     |> assign(:options, nil)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    maybe_join_game(socket)

    {:noreply, socket}
  end

  @impl true
  @spec handle_info(%{:event => <<_::96>>, optional(any()) => any()}, map()) :: {:noreply, map()}
  def handle_info(%{event: "game_started"}, socket) do
    {:noreply, assign(socket, :status, :starting)}
  end

  @impl true
  def handle_info(%{event: "game_playing", payload: %{round: round, options: options}}, socket) do
    {:noreply,
     socket
     |> assign(:round, round)
     |> assign(:options, options)
     |> assign(:status, :playing)}
  end

  defp maybe_join_game(socket) do
    if connected?(socket) do
      game_topic = @game_prefix_topic <> to_string(socket.assigns.game_id)
      player_name = socket.assigns.player_name

      Presence.track_player(self(), socket.assigns.game_id, player_name)
      Endpoint.subscribe(game_topic)
    end
  end

  defp get_button_color(index) do
    case index do
      0 -> "bg-red-500 hover:bg-red-600"
      1 -> "bg-blue-500 hover:bg-blue-600"
      2 -> "bg-green-500 hover:bg-green-600"
      3 -> "bg-yellow-500 hover:bg-yellow-600"
      _ -> "bg-gray-500 hover:bg-gray-600"
    end
  end
end
