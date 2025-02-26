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
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def option_button(assigns) do
    ~H"""
    <button type={@type} class={[classes(), @class]} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp classes do
    "phx-submit-loading:opacity-75 h-24 inline-grid place-content-center rounded-md transition duration-150 ease-in-out py-2 px-6 font-medium leading-6 border border-transparent active:translate-y-px text-white active:text-white/90"
  end
end
