defmodule LyricWeb.Ui.Feedback do
  use Phoenix.Component

  attr :is_correct?, :boolean, default: nil
  attr :rest, :global, include: ~w(class)

  def feedback(assigns) do
    ~H"""
    <div class="lc-feedback" {@rest}>
      <span class="lc-text">
        {get_icon(@is_correct?)}
      </span>

      <span class="sr-only">
        {get_text(@is_correct?)}
      </span>
    </div>
    """
  end

  defp get_icon(true) do
    positive_icons = ["👍", "🎉", "✅", "🌟", "😊", "👏", "💯", "🔥", "⭐", "🚀"]
    Enum.random(positive_icons)
  end

  defp get_icon(false) do
    negative_icons = ["👎", "❌", "😕", "🚫", "⛔", "💔", "😢", "👀", "⚠️", "🤔"]
    Enum.random(negative_icons)
  end

  defp get_icon(nil) do
    nil
  end

  defp get_text(true) do
    "Richtig"
  end

  defp get_text(false) do
    "Falsch"
  end

  defp get_text(nil) do
    "Keine Feedback"
  end
end
