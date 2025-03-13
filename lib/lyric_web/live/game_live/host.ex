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
    # lyrics = game.song.lyrics
    lyrics = %{
      "initial_timeout" => 12000,
      "lines" => [
        %{
          "text" => "I took an arrow to the heart",
          "word_to_guess" => "arrow",
          "options" => ["bullet", "arrow", "dagger", "blade"],
          "correct_index" => 1,
          "timeout" => 3000
        },
        %{
          "text" => "I never kissed a mouth that taste like yours",
          "word_to_guess" => "kissed",
          "options" => ["miss", "missed", "kiss", "kissed"],
          "correct_index" => 3,
          "timeout" => 4000
        },
        %{
          "text" => "Strawberries and somethin' more",
          "word_to_guess" => "Strawberries",
          "options" => ["Raspberries", "Honey", "Cherries", "Strawberries"],
          "correct_index" => 3,
          "timeout" => 3200
        },
        %{
          "text" => "Ooh, yeah, I want it all",
          "word_to_guess" => "want",
          "options" => ["need", "want", "take", "wanted"],
          "correct_index" => 1,
          "timeout" => 3300
        },
        %{
          "text" => "Lipstick on my guitar, ooh",
          "word_to_guess" => "guitar",
          "options" => ["guitar", "collar", "cigar", "memoir"],
          "correct_index" => 0,
          "timeout" => 4000
        },
        %{
          "text" => "Fill up the engines, we can drive real far",
          "word_to_guess" => "engines",
          "options" => ["feelings", "vehicle", "engines", "benches"],
          "correct_index" => 2,
          "timeout" => 3000
        },
        %{
          "text" => "Go dancing underneath the stars",
          "word_to_guess" => "stars",
          "options" => ["enhancing", "dancing", "balancing", "chance"],
          "correct_index" => 1,
          "timeout" => 4200
        },
        %{
          "text" => "Ooh, yeah, I want it all, mm",
          "word_to_guess" => "yeah",
          "options" => ["now", "all", "yeah", "too"],
          "correct_index" => 2,
          "timeout" => 2600
        },
        %{
          "text" => "Ooh, you got me feeling like",
          "word_to_guess" => "feeling",
          "options" => ["feel", "feeling", "dreaming", "wishing"],
          "correct_index" => 1,
          "timeout" => 3000
        },
        %{
          "text" => "I wanna be that guy I wanna kiss your eyes",
          "word_to_guess" => "kiss",
          "options" => ["kiss", "miss", "hold", "feel"],
          "correct_index" => 0,
          "timeout" => 3200
        },
        %{
          "text" => "I wanna drink that smile I wanna feel like I'm",
          "word_to_guess" => "smile",
          "options" => ["style", "while", "smile", "sight"],
          "correct_index" => 2,
          "timeout" => 4000
        },
        %{
          "text" => "Like my soul's on fire. I wanna stay up all day and all night, mm",
          "word_to_guess" => "fire",
          "options" => ["wire", "higher", "fire", "pyre"],
          "correct_index" => 2,
          "timeout" => 4200
        },
        %{
          "text" => "Yeah, you got me singing like",
          "word_to_guess" => "got",
          "options" => ["get", "had", "made", "got"],
          "correct_index" => 3,
          "timeout" => 4000
        }
      ]
    }

    {:ok, qr_code} = get_qr_code(id)

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
       |> assign(:lines_to_display, [])
       |> assign(:board_score, %{})
       |> assign(:ranked_players, [])}
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
     |> assign(:lines_to_display, [])
     |> assign(:board_score, %{})
     |> assign(:ranked_players, [])}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    players = Presence.list_players(to_string(socket.assigns.game.id))

    {:noreply, socket |> assign(:players, players)}
  end

  @impl true
  def handle_info({:publish_options, topic}, socket) do
    current_line = socket.assigns.current_line || 0

    if current_line >= length(socket.assigns.lyrics["lines"]) do
      Endpoint.broadcast(topic, "game_finished", %{})
      ranked_players = get_ranked_players(socket.assigns.players, socket.assigns.board_score)

      {:noreply,
       socket |> assign(:game_state, :finished) |> assign(:ranked_players, ranked_players)}
    else
      line =
        socket.assigns.lyrics
        |> Map.get("lines")
        |> Enum.at(current_line, %{})

      options =
        line
        |> Map.get("options", [])

      lines_to_display = get_lines_to_display(socket.assigns.lyrics, current_line)

      Endpoint.broadcast(topic, "options_published", %{
        options: options,
        lines_to_display: lines_to_display
      })

      timeout = socket.assigns.lyrics["lines"] |> Enum.at(current_line, %{}) |> Map.get("timeout")
      Process.send_after(self(), {:publish_options, topic}, timeout)

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
    current_line = socket.assigns.current_line - 1

    is_correct? =
      socket.assigns.lyrics["lines"]
      |> Enum.at(current_line, %{})
      |> Map.get("correct_index") == index

    send(pid, {:answer_corrected, is_correct?})
    score = Map.get(socket.assigns.board_score, pid, 0)
    new_score = if is_correct?, do: score + 100, else: score
    board_score = Map.put(socket.assigns.board_score, pid, new_score)

    {:noreply, socket |> assign(:board_score, board_score)}
  end

  @impl true
  def handle_event("start_game", _params, socket) do
    topic = @game_players_topic <> to_string(socket.assigns.game.id)
    Endpoint.broadcast(topic, "game_started", %{})

    timeout = socket.assigns.lyrics |> Map.get("initial_timeout")
    IO.inspect(timeout)
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
    lyrics["lines"]
    |> Enum.take(current_line_index + 1)
    |> Enum.with_index()
    |> Enum.map(fn {line, index} ->
      if index == current_line_index do
        mask_word(line["text"], line["word_to_guess"])
      else
        line["text"]
      end
    end)
  end

  defp mask_word(string, word) do
    mask = String.duplicate("_", String.length(word))
    String.replace(string, word, mask, case: :lower, count: 1)
  end

  defp get_ranked_players(players, board_score) do
    players
    |> Enum.map(fn player ->
      score = Map.get(board_score, player.pid, 0)
      player |> Map.put(:score, score)
    end)
    |> Enum.sort_by(& &1.score, :desc)
  end

  defp rank_badge_class(1),
    do:
      "flex items-center justify-center w-8 h-8 rounded-full bg-yellow-500 text-gray-900 font-bold"

  defp rank_badge_class(2),
    do:
      "flex items-center justify-center w-8 h-8 rounded-full bg-gray-400 text-gray-900 font-bold"

  defp rank_badge_class(3),
    do:
      "flex items-center justify-center w-8 h-8 rounded-full bg-yellow-700 text-gray-900 font-bold"

  defp rank_badge_class(_),
    do: "flex items-center justify-center w-8 h-8 rounded-full bg-gray-600 text-white font-bold"
end
