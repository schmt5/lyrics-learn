defmodule LyricWeb.GameLive.Play do
  use LyricWeb, :live_view

  alias LyricWeb.Presence
  alias LyricWeb.Endpoint

  @game_prefix_topic "game_session:"

  @impl true
  def mount(params, _session, socket) do
    game_id = Map.get(params, "id")

    {:ok,
     socket
     |> assign(:page_title, "Play Game")
     |> assign(:game_id, game_id)
     |> assign(:status, :joining)
     |> assign(:form, to_form(%{"player_name" => ""}))
     |> assign(:player_name, "")}
  end

  @impl true
  @spec handle_event(<<_::72>>, map(), Phoenix.LiveView.Socket.t()) :: {:noreply, map()}
  def handle_event("join_game", %{"player_name" => player_name}, socket) do
    maybe_join_game_as_player(socket, player_name)

    {:noreply, socket |> assign(:player_name, player_name) |> assign(:status, :waiting)}
  end

  defp maybe_join_game_as_player(socket, player_name) do
    if connected?(socket) do
      game_topic = @game_prefix_topic <> socket.assigns.game_id

      Presence.track_player(self(), socket.assigns.game_id, player_name)
      Endpoint.subscribe(game_topic)
    end
  end
end
