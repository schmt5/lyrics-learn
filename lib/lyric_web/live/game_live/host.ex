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
      initial_timeout: 3000,
      lines: [
        %{
          text: "I found a love for me",
          word_to_guess: "love",
          options: ["life", "love", "heart", "song"],
          correct_index: 1,
          timeout: 7700
        },
        %{
          text: "Oh, darling, just dive right in and follow my lead",
          word_to_guess: "dive",
          options: ["dance", "drive", "dive", "might"],
          correct_index: 2,
          timeout: 7300
        },
        %{
          text: "Well, I found a girl, beautiful and sweet",
          word_to_guess: "girl",
          options: ["girl", "angel", "lady", "soul"],
          correct_index: 0,
          timeout: 7600
        },
        %{
          text: "Oh, I never knew you were the someone waiting for me",
          word_to_guess: "waiting",
          options: ["looking", "waiting", "hoping", "calling"],
          correct_index: 1,
          timeout: 6800
        },
        %{
          text: "Cause we were just kids when we fell in love",
          word_to_guess: "kids",
          options: ["teens", "kids", "young", "friends"],
          correct_index: 1,
          timeout: 4500
        },
        %{
          text: "Not knowing what it was",
          word_to_guess: "knowing",
          options: ["knowing", "feeling", "thinking", "seeing"],
          correct_index: 0,
          timeout: 4200
        },
        %{
          text: "I will not give you up this time",
          word_to_guess: "give",
          options: ["give", "let", "throw", "push"],
          correct_index: 0,
          timeout: 7400
        },
        %{
          text: "But darling, just kiss me slow, your heart is all I own",
          word_to_guess: "heart",
          options: ["love", "soul", "heart", "mind"],
          correct_index: 2,
          timeout: 7200
        },
        %{
          text: "And in your eyes you're holding mine",
          word_to_guess: "eyes",
          options: ["arms", "eyes", "hands", "heart"],
          correct_index: 1,
          timeout: 7000
        },
        %{
          text: "Baby, I'm dancing in the dark with you between my arms",
          word_to_guess: "dancing",
          options: ["swaying", "dancing", "singing", "standing"],
          correct_index: 1,
          timeout: 10000
        },
        %{
          text: "Barefoot on the grass, listening to our favorite song",
          word_to_guess: "favorite",
          options: ["special", "favorite", "chosen", "perfect"],
          correct_index: 1,
          timeout: 7950
        },
        %{
          text: "When you said you looked a mess, I whispered underneath my breath",
          word_to_guess: "whispered",
          options: ["whispered", "muttered", "mumbled", "said"],
          correct_index: 0,
          timeout: 7600
        },
        %{
          text: "But you heard it, darling, you look perfect tonight",
          word_to_guess: "perfect",
          options: ["beautiful", "gorgeous", "amazing", "perfect"],
          correct_index: 3,
          timeout: 13500
        },
        %{
          text: "Well I found a woman, stronger than anyone I know",
          word_to_guess: "stronger",
          options: ["better", "kinder", "stronger", "wiser"],
          correct_index: 2,
          timeout: 7100
        },
        %{
          text: "She shares my dreams, I hope that someday I'll share her home",
          word_to_guess: "dreams",
          options: ["life", "dreams", "future", "world"],
          correct_index: 1,
          timeout: 8000
        },
        %{
          text: "I found a love, to carry more than just my secrets",
          word_to_guess: "secrets",
          options: ["burdens", "secrets", "sorrows", "worries"],
          correct_index: 1,
          timeout: 9000
        },
        %{
          text: "To carry love, to carry children of our own",
          word_to_guess: "children",
          options: ["memories", "promises", "children", "future"],
          correct_index: 2,
          timeout: 5450
        },
        %{
          text: "We are still kids, but we're so in love",
          word_to_guess: "kids",
          options: ["young", "kids", "dreamers", "growing"],
          correct_index: 1,
          timeout: 4500
        },
        %{
          text: "Fighting against all odds",
          word_to_guess: "odds",
          options: ["odds", "challenges", "obstacles", "doubts"],
          correct_index: 0,
          timeout: 4300
        },
        %{
          text: "I know we'll be alright this time",
          word_to_guess: "alright",
          options: ["happy", "together", "alright", "perfect"],
          correct_index: 2,
          timeout: 7000
        },
        %{
          text: "Darling, just hold my hand",
          word_to_guess: "hold",
          options: ["take", "hold", "grasp", "touch"],
          correct_index: 1,
          timeout: 4100
        },
        %{
          text: "Be my girl, I'll be your man",
          word_to_guess: "girl",
          options: ["girl", "love", "wife", "partner"],
          correct_index: 0,
          timeout: 4100
        },
        %{
          text: "I see my future in your eyes",
          word_to_guess: "future",
          options: ["dreams", "hope", "love", "future"],
          correct_index: 3,
          timeout: 4700
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

    if current_line >= length(socket.assigns.lyrics.lines) do
      Endpoint.broadcast(topic, "game_finished", %{})
      ranked_players = get_ranked_players(socket.assigns.players, socket.assigns.board_score)

      {:noreply,
       socket |> assign(:game_state, :finished) |> assign(:ranked_players, ranked_players)}
    else
      line =
        socket.assigns.lyrics.lines
        |> Enum.at(current_line, %{})

      options =
        line
        |> Map.get(:options, [])

      text = line |> Map.get(:text) |> mask_word(line.word_to_guess)

      Endpoint.broadcast(topic, "options_published", %{
        options: options,
        text: text
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
    current_line = socket.assigns.current_line - 1

    is_correct? =
      socket.assigns.lyrics.lines
      |> Enum.at(current_line, %{})
      |> Map.get(:correct_index) == index

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
