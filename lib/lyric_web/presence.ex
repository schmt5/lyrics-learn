defmodule LyricWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.
  """

  use Phoenix.Presence,
    otp_app: :lyric,
    pubsub_server: Lyric.PubSub

  alias LyricWeb.Presence
  alias LyricWeb.Endpoint

  @player_activity_prefix_topic "player_activity:"

  def subscribeToPlayerActivity(game_id) do
    topic = @player_activity_prefix_topic <> game_id

    Endpoint.subscribe(topic)
  end

  def track_player(pid, game_id, player_name) do
    topic = @player_activity_prefix_topic <> game_id

    Presence.track(pid, topic, "players", %{
      name: player_name
    })
  end

  def list_players(game_id) do
    topic = @player_activity_prefix_topic <> game_id

    Presence.list(topic) |> get_in(["players", :metas]) || []
  end
end
