defmodule LyricWeb.GameLive.Host do
  alias LyricWeb.Endpoint
  use LyricWeb, :live_view

  alias LyricWeb.Presence
  alias Lyric.Playground

  @game_players_topic "game_players_session:"
  @game_host_topic "game_host_session:"

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    game = Playground.get_game_with_song!(id)
    {:ok, qr_code} = get_qr_code(id)

    lyrics = %{
      initial_timeout: 3100,
      lines: [
        %{
          text: "I found a love for me",
          word_to_guess: "love",
          options: ["water", "love", "apple", "red"],
          correct_index: 1,
          timeout: 7800
        },
        %{
          text: "Oh, darling, just dive right in and follow my lead",
          word_to_guess: "dive",
          options: ["beef", "drive", "dive", "might"],
          correct_index: 2,
          timeout: 7300
        },
        %{
          text: "Well, I found a girl, beautiful and sweet",
          word_to_guess: "girl",
          options: ["girl", "woman", "man", "squirl"],
          correct_index: 0,
          timeout: 10000
        }
      ]
    }

    if not connected?(socket) do
      {:ok,
       socket
       |> assign(:page_title, "Host Game")
       |> assign(:game, game)
       |> assign(:game_state, :waiting)
       |> assign(:players, [])
       |> assign(:qr_code, qr_code)
       |> assign(:current_line, nil)
       |> assign(:lyrics, lyrics)
       |> assign(:lines_to_display, [])}
    end

    host_topic = @game_host_topic <> to_string(id)
    Endpoint.subscribe(host_topic)
    Presence.subscribe_to_player_activity(id)
    players = Presence.list_players(id)

    {:ok,
     socket
     |> assign(:page_title, "Host Game")
     |> assign(:game, game)
     |> assign(:game_state, :waiting)
     |> assign(:players, players)
     |> assign(:qr_code, qr_code)
     |> assign(:current_line, nil)
     |> assign(:lyrics, lyrics)
     |> assign(:lines_to_display, [])}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    players = Presence.list_players(to_string(socket.assigns.game.id))

    {:noreply, socket |> assign(:players, players)}
  end

  @impl true
  def handle_info({:publish_options, topic}, socket) do
    current_line = socket.assigns.current_line || 0

    if current_line >= length(socket.assigns.lyrics.lines) do
      Endpoint.broadcast(topic, "game_finished", %{})
      {:noreply, socket |> assign(:game_state, :finished)}
    else
      options =
        socket.assigns.lyrics.lines
        |> Enum.at(current_line, %{})
        |> Map.get(:options, [])

      Endpoint.broadcast(topic, "options_published", %{
        options: options
      })

      timeout = socket.assigns.lyrics.lines |> Enum.at(current_line, %{}) |> Map.get(:timeout)
      Process.send_after(self(), {:publish_options, topic}, timeout)

      lines_to_display = get_lines_to_display(socket.assigns.lyrics, current_line)

      {:noreply,
       socket
       |> assign(:current_line, current_line + 1)
       |> assign(:lines_to_display, lines_to_display)}
    end
  end

  def handle_info(
        %{
          event: "option_selected",
          payload: %{
            pid: pid,
            index: index
          }
        },
        socket
      ) do
    IO.inspect(pid)
    IO.inspect(index)

    current_line = socket.assigns.current_line - 1

    is_correct? =
      socket.assigns.lyrics.lines
      |> Enum.at(current_line, %{})
      |> Map.get(:correct_index) == index

    send(pid, {:answer_corrected, is_correct?})

    {:noreply, socket}
  end

  @impl true
  def handle_event("start_game", _params, socket) do
    topic = @game_players_topic <> to_string(socket.assigns.game.id)
    Endpoint.broadcast(topic, "game_started", %{})

    timeout = socket.assigns.lyrics.initial_timeout
    Process.send_after(self(), {:publish_options, topic}, timeout)

    {:noreply, socket |> assign(:game_state, :playing) |> assign(:current_line, 0)}
  end

  defp get_qr_code(id) do
    joining_url = LyricWeb.Endpoint.url() <> "/games/#{id}/join"

    joining_url
    |> QRCode.create(:medium)
    |> QRCode.render()
    |> QRCode.to_base64()
  end

  defp get_lines_to_display(lyrics, current_line_index) do
    lyrics.lines
    |> Enum.take(current_line_index + 1)
    |> Enum.map(fn line ->
      mask_word(line.text, line.word_to_guess)
    end)
  end

  defp mask_word(string, word) do
    String.replace(string, word, "_____", case: :lower, count: 1)
  end
end
