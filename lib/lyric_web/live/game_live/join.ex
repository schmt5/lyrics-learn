defmodule LyricWeb.GameLive.Join do
  use LyricWeb, :live_view

  def mount(params, _session, socket) do
    game_id = Map.get(params, "id")

    {:ok,
     socket
     |> assign(:page_title, "Spiel beitreten")
     |> assign(:game_id, game_id)
     |> assign(:form, to_form(%{"player_name" => ""}))}
  end

  def handle_event("join_game", %{"player_name" => player_name}, socket) do
    game_id = socket.assigns.game_id

    {:noreply, push_navigate(socket, to: ~p"/games/#{game_id}/play?player_name=#{player_name}")}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto">
      <.form for={@form} phx-submit="join_game">
        <.input type="text" field={@form[:player_name]} label="Name" required />
        <.button type="submit" class="mt-4 w-full">Spiel beitreten</.button>
      </.form>
    </div>
    """
  end
end
