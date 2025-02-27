defmodule LyricWeb.GameLive.Play do
  use LyricWeb, :live_view

  alias LyricWeb.Presence
  alias LyricWeb.Endpoint

  @game_players_topic "game_players_session:"
  @game_host_topic "game_host_session:"

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
     |> assign(:text, nil)
     |> assign(:options, nil)
     |> assign(:disabled?, false)
     |> assign(:is_correct?, nil)}
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

  @impl true
  def handle_info(
        %{event: "options_published", payload: %{options: options, text: text}},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:disabled?, false)
     |> assign(:is_correct?, nil)
     |> assign(:text, text)
     |> assign(:options, options)}
  end

  def handle_info(%{event: "game_finished"}, socket) do
    {:noreply, assign(socket, :status, :finished)}
  end

  def handle_info({:answer_corrected, is_correct?}, socket) do
    {:noreply, assign(socket, :is_correct?, is_correct?)}
  end

  @impl true
  def handle_event("select_option", %{"index" => index}, socket) do
    topic = @game_host_topic <> to_string(socket.assigns.game_id)

    Endpoint.broadcast(topic, "option_selected", %{
      pid: self(),
      index: String.to_integer(index)
    })

    {:noreply, socket |> assign(:disabled?, true)}
  end

  defp maybe_join_game(socket) do
    if connected?(socket) do
      game_topic = @game_players_topic <> to_string(socket.assigns.game_id)
      player_name = socket.assigns.player_name

      Presence.track_player(self(), socket.assigns.game_id, player_name)
      Endpoint.subscribe(game_topic)
    end
  end
end
