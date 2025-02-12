defmodule Lyric.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :song_id, references(:songs, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:games, [:song_id])
  end
end
