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
  @colors [
    "#E6F2FF",
    "#FFEBF0",
    "#F0FFF0",
    "#FFF0E6",
    "#F2E6FF",
    "#FFFFD6",
    "#E6FFFA",
    "#FFE6F0",
    "#F5FFE6",
    "#E6F0FF",
    "#FFF5E6",
    "#F0E6FF"
  ]

  def subscribe_to_player_activity(game_id) do
    topic = @player_activity_prefix_topic <> game_id

    Endpoint.subscribe(topic)
  end

  def track_player(pid, game_id, player_name) do
    topic = @player_activity_prefix_topic <> game_id
    color = Enum.random(@colors)

    Presence.track(pid, topic, "players", %{
      pid: pid,
      name: player_name,
      color: color
    })
  end

  def list_players(game_id) do
    topic = @player_activity_prefix_topic <> game_id

    IO.inspect(Presence.list(topic))
    Presence.list(topic) |> get_in(["players", :metas]) || []
  end
end
