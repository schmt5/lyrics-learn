defmodule Lyric.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :title, :string
      add :artist, :string
      add :album, :string

      timestamps(type: :utc_datetime)
    end
  end
end
