defmodule LyricWeb.Ui.Feedback do
  use Phoenix.Component

  attr :is_correct?, :boolean, default: nil
  attr :rest, :global, include: ~w(class)

  def feedback(assigns) do
    ~H"""
    <div class="lc-feedback" {@rest}>
      <%= case @is_correct? do %>
        <% true -> %>
          <span class="lc-text">👍</span> <span class="sr-only">Richtig</span>
        <% false -> %>
          <span class="lc-text">👎</span> <span class="sr-only">Falsch</span>
        <% nil -> %>
          <p class="sr-only">Keine Feedback</p>
      <% end %>
    </div>
    """
  end
end
