defmodule LawAdvisorRyanTestWeb.CoreComponents.Navigation do
  @moduledoc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  use Phoenix.Component

  alias LawAdvisorRyanTestWeb.CoreComponents, as: CC

  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <CC.a
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <Heroicons.arrow_left solid class="w-3 h-3 stroke-current inline" />
        <%= render_slot(@inner_block) %>
      </CC.a>
    </div>
    """
  end
end
