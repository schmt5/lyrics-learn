defmodule LyricWeb.SongLive.LyricsTextTemplate do
  perfect_short_lyrics = %{
    title: "Perfect",
    artist: "Ed Sheeran",
    album: "÷ (Divide)",
    lyrics: %{
      initial_timeout: 3000,
      lines: [
        %{
          text: "I found a love for me",
          word_to_guess: "love",
          options: ["life", "love", "leave", "bird"],
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
          word_to_guess: "grass",
          options: ["sand", "grass", "path", "shore"],
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
        }
      ]
    }
  }

  perfect_long_lyrics = %{
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
end
