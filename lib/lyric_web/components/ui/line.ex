defmodule LyricWeb.Ui.Line do
  use Phoenix.Component

  attr :index, :integer, default: nil
  attr :total, :integer, default: nil
  attr :text, :string, default: nil

  slot :inner_block, required: true

  def line(assigns) do
    ~H"""
    <p class={styles(@index, @total)}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  defp styles(index, total) do
    base_styles = "text-2xl font-bold text-center text-sky-800"
    first_line_styles = if index == 0, do: "pt-96", else: ""

    opacity_styles =
      cond do
        is_nil(index) or is_nil(total) -> ""
        # Last line (most recent) - full opacity
        index == total - 1 -> ""
        # All earlier lines - 25% opacity
        true -> "opacity-30"
      end

    "#{base_styles} #{first_line_styles} #{opacity_styles}"
  end
end
