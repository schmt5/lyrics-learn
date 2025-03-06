defmodule Lyric.Repo.Migrations.AddLyricsToSongs do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :lyrics, :map
    end
  end
end
