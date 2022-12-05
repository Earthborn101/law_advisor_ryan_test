defmodule LawAdvisorRyanTestWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.

  Icons are provided by [heroicons](https://heroicons.com), using the
  [heroicons_elixir](https://github.com/mveytsman/heroicons_elixir) project.

  Other custom components here are from Petal Components.
  See the [Petal Components Document](https://petal.build) for more information.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias LawAdvisorRyanTestWeb.CoreComponents

  ## Link Component
  def a(assigns), do: CoreComponents.Link.a(assigns)

  ## Alert Component
  def alert(assigns), do: CoreComponents.Alert.alert(assigns)

  ## Avatar Components
  def avatar_group(assigns), do: CoreComponents.Avatar.avatar_group(assigns)
  def avatar(assigns), do: CoreComponents.Avatar.avatar(assigns)

  ## Badge Component
  def badge(assigns), do: CoreComponents.Badge.badge(assigns)

  ## Breadcrumbs Component
  def breadcrumbs(assigns), do: CoreComponents.breadcrumbs(assigns)

  ## Button Components
  def button(assigns), do: CoreComponents.Button.button(assigns)
  def icon_button(assigns), do: CoreComponents.Button.icon_button(assigns)

  ## Card Components
  def card_content(assigns), do: CoreComponents.Card.card_content(assigns)
  def card_footer(assigns), do: CoreComponents.Card.card_footer(assigns)
  def card_media(assigns), do: CoreComponents.Card.card_media(assigns)
  def card(assigns), do: CoreComponents.Card.card(assigns)

  ## Container Component
  def container(assigns), do: CoreComponents.Container.container(assigns)

  ## Dropdown Component
  def dropdown(assigns), do: CoreComponents.Dropdown.dropdown(assigns)

  ## Header Component
  def header(assigns), do: CoreComponents.Header.header(assigns)

  ## Loading Component
  def spinner(assigns), do: CoreComponents.Loading.spinner(assigns)

  ## Progress Component
  def progress(assigns), do: CoreComponents.Progress.progress(assigns)

  ## Table Components
  def table(assigns), do: CoreComponents.Table.table(assigns)
  def td(assigns), do: CoreComponents.Table.td(assigns)
  def th(assigns), do: CoreComponents.Table.th(assigns)
  def tr(assigns), do: CoreComponents.Table.tr(assigns)

  ## Tabs Components
  def tabs(assigns), do: CoreComponents.Tabs.tabs(assigns)
  def tab(assigns), do: CoreComponents.Tabs.tab(assigns)

  ## Typography Components
  def h1(assigns), do: CoreComponents.Typography.h1(assigns)
  def h2(assigns), do: CoreComponents.Typography.h2(assigns)
  def h3(assigns), do: CoreComponents.Typography.h3(assigns)
  def h4(assigns), do: CoreComponents.Typography.h4(assigns)
  def h5(assigns), do: CoreComponents.Typography.h5(assigns)
  def p(assigns), do: CoreComponents.Typography.p(assigns)

  ## Flash Component
  def flash(assigns), do: CoreComponents.Flash.flash(assigns)

  ## Modal Component
  def modal(assigns), do: CoreComponents.Modal.modal(assigns)
  def slide_over(assigns), do: CoreComponents.Modal.slide_over(assigns)

  ## Error Component
  def error(assigns), do: CoreComponents.Error.error(assigns)

  ## Label Components
  def label(assigns), do: CoreComponents.Label.label(assigns)

  ## Input Components
  def input(assigns), do: CoreComponents.Input.input(assigns)

  ## Form Components
  def simple_form(assigns), do: CoreComponents.Form.simple_form(assigns)

  ## Navigation Components
  def back(assigns), do: CoreComponents.Navigation.back(assigns)

  ## JS Commands
  def hide_modal(js \\ %JS{}, selector),
    do: CoreComponents.JsCommandHelpers.hide_modal(js, selector)

  def hide(js \\ %JS{}, selector), do: CoreComponents.JsCommandHelpers.hide(js, selector)

  def show_modal(js \\ %JS{}, selector),
    do: CoreComponents.JsCommandHelpers.show_modal(js, selector)

  def show(js \\ %JS{}, selector), do: CoreComponents.JsCommandHelpers.show(js, selector)
end
