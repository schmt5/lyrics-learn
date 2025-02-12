defmodule LyricWeb.SongLive.FormComponent do
  use LyricWeb, :live_component

  alias Lyric.Musics

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage song records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="song-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:artist]} type="text" label="Artist" />
        <.input field={@form[:album]} type="text" label="Album" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Song</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{song: song} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Musics.change_song(song))
     end)}
  end

  @impl true
  def handle_event("validate", %{"song" => song_params}, socket) do
    changeset = Musics.change_song(socket.assigns.song, song_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"song" => song_params}, socket) do
    save_song(socket, socket.assigns.action, song_params)
  end

  defp save_song(socket, :edit, song_params) do
    case Musics.update_song(socket.assigns.song, song_params) do
      {:ok, song} ->
        notify_parent({:saved, song})

        {:noreply,
         socket
         |> put_flash(:info, "Song updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_song(socket, :new, song_params) do
    case Musics.create_song(song_params) do
      {:ok, song} ->
        notify_parent({:saved, song})

        {:noreply,
         socket
         |> put_flash(:info, "Song created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
