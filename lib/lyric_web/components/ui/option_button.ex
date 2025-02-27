defmodule LyricWeb.Ui.OptionButton do
  use Phoenix.Component

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :index, :integer, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def option_button(assigns) do
    ~H"""
    <button type={@type} class={[classes(), get_button_color(@index), @class]} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp classes do
    "h-20 inline-grid place-content-center rounded-md transition duration-150 ease-in-out py-2 px-6 font-medium leading-6 active:translate-y-px text-white active:text-white/90 text-xl uppercase trackin-wider border-b-4 active:border-transparent shadow-lg disabled:opacity-50 disabled:pointer-events-none"
  end

  defp get_button_color(index) do
    case index do
      0 -> "bg-red-500 hover:bg-red-600 border-red-700"
      1 -> "bg-blue-500 hover:bg-blue-600 border-blue-700"
      2 -> "bg-green-500 hover:bg-green-600 border-green-700"
      3 -> "bg-yellow-500 hover:bg-yellow-600 border-yellow-700"
      _ -> "bg-gray-500 hover:bg-gray-600 border-gray-700"
    end
  end
end
