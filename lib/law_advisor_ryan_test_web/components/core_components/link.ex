defmodule LawAdvisorRyanTestWeb.CoreComponents.Link do
  @moduledoc """
  Renders a link.

  ## Examples

      <.a link_type="live_patch" to="#">
        Sample Link
      </.a>
  """
  use Phoenix.Component

  import LawAdvisorRyanTestWeb.CoreComponents.Helpers

  attr :link_type, :string, default: "a"
  attr :label, :string, default: nil
  attr :to, :any

  slot :inner_block

  def a(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:link_type, fn -> "a" end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:to, fn -> nil end)
      |> assign_new(:inner_block, fn -> nil end)
      |> assign_rest(~w(class link_type label to)a)

    ~H"""
    <.custom_link
      inner_block={@inner_block}
      link_type={@link_type}
      to={@to}
      rest={@rest}
      class={@class}
      label={@label}
    />
    """
  end

  def custom_link(%{link_type: "a"} = assigns) do
    ~H"""
    <%= Phoenix.HTML.Link.link([to: @to, class: @class] ++ @rest,
      do: if(@inner_block, do: render_slot(@inner_block), else: @label)
    ) %>
    """
  end

  def custom_link(%{link_type: "live_patch"} = assigns) do
    ~H"""
    <%= live_patch([to: @to, class: @class] ++ @rest,
      do: if(@inner_block, do: render_slot(@inner_block), else: @label)
    ) %>
    """
  end

  def custom_link(%{link_type: "live_redirect"} = assigns) do
    ~H"""
    <%= live_redirect([to: @to, class: @class] ++ @rest,
      do: if(@inner_block, do: render_slot(@inner_block), else: @label)
    ) %>
    """
  end

  def custom_link(%{link_type: "button"} = assigns) do
    ~H"""
    <button class={@class} {@rest}>
      <%= if @inner_block, do: render_slot(@inner_block), else: @label %>
    </button>
    """
  end
end
