defmodule Lyric.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :lyric

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def reset_db do
    load_app()

    for repo <- repos() do
      {:ok, _, _} =
        Ecto.Migrator.with_repo(repo, fn repo ->
          # Get all tables except schema_migrations
          tables_query = """
          SELECT name FROM sqlite_master
          WHERE type='table'
          AND name != 'schema_migrations'
          AND name NOT LIKE 'sqlite_%'
          """

          %{rows: tables} = Ecto.Adapters.SQL.query!(repo, tables_query)

          # Disable foreign key constraints temporarily
          Ecto.Adapters.SQL.query!(repo, "PRAGMA foreign_keys = OFF")

          # Drop all tables except schema_migrations
          for [table] <- tables do
            Ecto.Adapters.SQL.query!(repo, "DROP TABLE #{table}")
          end

          # Re-enable foreign key constraints
          Ecto.Adapters.SQL.query!(repo, "PRAGMA foreign_keys = ON")

          # Re-run migrations
          Ecto.Migrator.run(repo, :up, all: true)

          {:ok, [], []}
        end)
    end
  end

  def setup do
    load_app()

    # Ensure the application and all dependencies are started
    Application.ensure_all_started(@app)

    # Create the songs
    Lyric.Musics.create_song(%{
      title: "Perfect",
      artist: "Ed Sheeran",
      album: "÷ (Divide)",
      lyrics: %{
        "initial_timeout" => 3000,
        "lines" => [
          %{
            "text" => "I found a love for me",
            "word_to_guess" => "love",
            "options" => ["life", "love", "leave", "bird"],
            "correct_index" => 1,
            "timeout" => 7700
          },
          %{
            "text" => "Oh, darling, just dive right in and follow my lead",
            "word_to_guess" => "dive",
            "options" => ["dance", "drive", "dive", "might"],
            "correct_index" => 2,
            "timeout" => 7300
          },
          %{
            "text" => "Well, I found a girl, beautiful and sweet",
            "word_to_guess" => "girl",
            "options" => ["girl", "angel", "lady", "soul"],
            "correct_index" => 0,
            "timeout" => 7600
          },
          %{
            "text" => "Oh, I never knew you were the someone waiting for me",
            "word_to_guess" => "waiting",
            "options" => ["looking", "waiting", "hoping", "calling"],
            "correct_index" => 1,
            "timeout" => 6800
          },
          %{
            "text" => "Cause we were just kids when we fell in love",
            "word_to_guess" => "kids",
            "options" => ["teens", "kids", "young", "friends"],
            "correct_index" => 1,
            "timeout" => 4500
          },
          %{
            "text" => "Not knowing what it was",
            "word_to_guess" => "knowing",
            "options" => ["knowing", "feeling", "thinking", "seeing"],
            "correct_index" => 0,
            "timeout" => 4200
          },
          %{
            "text" => "I will not give you up this time",
            "word_to_guess" => "give",
            "options" => ["give", "let", "throw", "push"],
            "correct_index" => 0,
            "timeout" => 7400
          },
          %{
            "text" => "But darling, just kiss me slow, your heart is all I own",
            "word_to_guess" => "heart",
            "options" => ["love", "soul", "heart", "mind"],
            "correct_index" => 2,
            "timeout" => 7200
          },
          %{
            "text" => "And in your eyes you're holding mine",
            "word_to_guess" => "eyes",
            "options" => ["arms", "eyes", "hands", "heart"],
            "correct_index" => 1,
            "timeout" => 7000
          },
          %{
            "text" => "Baby, I'm dancing in the dark with you between my arms",
            "word_to_guess" => "dancing",
            "options" => ["swaying", "dancing", "singing", "standing"],
            "correct_index" => 1,
            "timeout" => 10000
          },
          %{
            "text" => "Barefoot on the grass, listening to our favorite song",
            "word_to_guess" => "grass",
            "options" => ["sand", "grass", "path", "shore"],
            "correct_index" => 1,
            "timeout" => 7950
          },
          %{
            "text" => "When you said you looked a mess, I whispered underneath my breath",
            "word_to_guess" => "whispered",
            "options" => ["whispered", "muttered", "mumbled", "said"],
            "correct_index" => 0,
            "timeout" => 7600
          },
          %{
            "text" => "But you heard it, darling, you look perfect tonight",
            "word_to_guess" => "perfect",
            "options" => ["beautiful", "gorgeous", "amazing", "perfect"],
            "correct_index" => 3,
            "timeout" => 13500
          }
        ]
      }
    })

    Lyric.Musics.create_song(%{
      title: "Shivers",
      artist: "Ed Sheeran",
      album: "÷ (Divide)",
      lyrics: %{
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
    })
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
