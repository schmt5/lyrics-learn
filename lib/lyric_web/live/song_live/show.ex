defmodule LyricWeb.SongLive.Show do
  alias Lyric.Playground
  use LyricWeb, :live_view

  alias Lyric.Musics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:song, Musics.get_song!(id))}
  end

  @impl true
  def handle_event("create_game", _params, socket) do
    case Playground.create_game(%{song_id: socket.assigns.song.id}) do
      {:ok, game} ->
        {:noreply,
         socket
         |> push_navigate(to: ~p"/games/#{game.id}")}

      {:error, _changeset} ->
        {:noreply, socket |> put_flash(:error, "Failed to create game")}
    end
  end

  defp page_title(:show), do: "Show Song"
  defp page_title(:edit), do: "Edit Song"
end
