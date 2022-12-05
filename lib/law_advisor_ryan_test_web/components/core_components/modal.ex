defmodule LawAdvisorRyanTestWeb.CoreComponents.Modal do
  @moduledoc """
  Renders a modal.

  ## Examples
      <.modal id="confirm-modal">
        Are you sure?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>

  JS commands may be passed to the `:on_cancel` and `on_confirm` attributes
  for the caller to react to each button press, for example:

      <.modal id="confirm" on_confirm={JS.push("delete")} on_cancel={JS.navigate(~p"/posts")}>
        Are you sure you?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import LawAdvisorRyanTestWeb.CoreComponents
  import LawAdvisorRyanTestWeb.CoreComponents.Helpers
  import LawAdvisorRyanTestWeb.Gettext

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}

  slot :inner_block, required: true
  slot :title
  slot :subtitle
  slot :confirm
  slot :cancel

  def modal(assigns) do
    ~H"""
    <div id={@id} phx-mounted={@show && show_modal(@id)} class="relative z-50 hidden">
      <div id={"#{@id}-bg"} class="fixed inset-0 bg-zinc-50/90 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-mounted={@show && show_modal(@id)}
              phx-window-keydown={hide_modal(@on_cancel, @id)}
              phx-key="escape"
              phx-click-away={hide_modal(@on_cancel, @id)}
              class="hidden relative rounded-2xl bg-white p-14 shadow-lg shadow-zinc-700/10 ring-1 ring-zinc-700/10 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={hide_modal(@on_cancel, @id)}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <Heroicons.x_mark solid class="h-5 w-5 stroke-current" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <header :if={@title != []}>
                  <h1 id={"#{@id}-title"} class="text-lg font-semibold leading-8 text-zinc-800">
                    <%= render_slot(@title) %>
                  </h1>
                  <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
                    <%= render_slot(@subtitle) %>
                  </p>
                </header>
                <%= render_slot(@inner_block) %>
                <div :if={@confirm != [] or @cancel != []} class="ml-6 mb-4 flex items-center gap-5">
                  <.button
                    :for={confirm <- @confirm}
                    id={"#{@id}-confirm"}
                    phx-click={@on_confirm}
                    phx-disable-with
                    class="py-2 px-3"
                  >
                    <%= render_slot(confirm) %>
                  </.button>
                  <.link
                    :for={cancel <- @cancel}
                    phx-click={hide_modal(@on_cancel, @id)}
                    class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                  >
                    <%= render_slot(cancel) %>
                  </.link>
                </div>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a slide over component. A Slide Over is a UI element that presents
  a panel that slides in above the main view, leaving the underlying content
  partially visible. It is normally used when the user needs additional
  content/information.

  Check-out https://petal.build/components/slide_over on how to use the component.
  """
  attr :origin, :string, values: ["left", "top", "bottom", "right"]
  attr :title, :string
  attr :max_width, :string
  slot :inner_block

  def slide_over(assigns) do
    assigns =
      assigns
      |> assign_new(:origin, fn -> "right" end)
      |> assign_new(:max_width, fn -> "md" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_rest(~w(class max_width title origin)a)

    ~H"""
    <div {@rest} id="slide-over">
      <div
        id="slide-over-overlay"
        class="fixed inset-0 z-50 transition-opacity bg-gray-900 dark:bg-gray-900 bg-opacity-30 dark:bg-opacity-70"
        aria-hidden="true"
      >
      </div>

      <div
        class={
          build_class([
            "fixed inset-0 z-50 flex overflow-hidden transform",
            get_margin_classes(@origin),
            @class
          ])
        }
        role="dialog"
        aria-modal="true"
      >
        <div
          id="slide-over-content"
          class={get_classes(@max_width, @origin, @class)}
          phx-click-away={hide_slide_over(@origin)}
          phx-window-keydown={hide_slide_over(@origin)}
          phx-key="escape"
        >
          <!-- Header -->
          <div class="px-5 py-3 border-b border-gray-100 dark:border-gray-600">
            <div class="flex items-center justify-between">
              <div class="font-semibold text-gray-800 dark:text-gray-200">
                <%= @title %>
              </div>

              <button phx-click={hide_slide_over(@origin)} class="text-gray-400 hover:text-gray-500">
                <div class="sr-only">Close</div>
                <svg class="w-4 h-4 fill-current">
                  <path d="M7.95 6.536l4.242-4.243a1 1 0 111.415 1.414L9.364 7.95l4.243 4.242a1 1 0 11-1.415 1.415L7.95 9.364l-4.243 4.243a1 1 0 01-1.414-1.415L6.536 7.95 2.293 3.707a1 1 0 011.414-1.414L7.95 6.536z" />
                </svg>
              </button>
            </div>
          </div>
          <!-- Content -->
          <div class="p-5">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # The live view that calls <.slide_over> will need to handle the "close_slide_over" event. eg:
  # def handle_event("close_slide_over", _, socket) do
  #   {:noreply, push_patch(socket, to: Routes.moderate_users_path(socket, :index))}
  # end
  def hide_slide_over(js \\ %JS{}, origin) do
    origin_class =
      case origin do
        x when x in ["left", "right"] -> "translate-x-0"
        x when x in ["top", "bottom"] -> "translate-y-0"
      end

    destination_class =
      case origin do
        "left" -> "-translate-x-full"
        "right" -> "translate-x-full"
        "top" -> "-translate-y-full"
        "bottom" -> "translate-y-full"
      end

    js
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.hide(
      transition: {
        "ease-in duration-200",
        "opacity-100",
        "opacity-0"
      },
      to: "#slide-over-overlay"
    )
    |> JS.hide(
      transition: {
        "ease-in duration-200",
        origin_class,
        destination_class
      },
      to: "#slide-over-content"
    )
    |> JS.push("close_slide_over")
  end

  defp get_classes(max_width, origin, class) do
    base_classes = "w-full max-h-full overflow-auto bg-white shadow-lg dark:bg-gray-800"
    slide_over_classes = slide_over_classes(origin)

    max_width_class =
      case origin do
        x when x in ["left", "right"] ->
          case max_width do
            "sm" -> "max-w-sm"
            "md" -> "max-w-xl"
            "lg" -> "max-w-3xl"
            "xl" -> "max-w-5xl"
            "2xl" -> "max-w-7xl"
            "full" -> "max-w-full"
          end

        x when x in ["top", "bottom"] ->
          ""
      end

    custom_classes = class

    build_class([slide_over_classes, max_width_class, base_classes, custom_classes])
  end

  defp slide_over_classes(origin) do
    case origin do
      "left" -> "transition translate-x-0"
      "right" -> "transition translate-x-0 absolute right-0 inset-y-0"
      "top" -> "transition translate-y-0 absolute inset-x-0"
      "bottom" -> "transition translate-y-0 absolute inset-x-0 bottom-0"
    end
  end

  defp get_margin_classes(margin) do
    case margin do
      "left" -> "mr-10"
      "right" -> "ml-10"
      "top" -> "mb-10"
      "bottom" -> "mt-10"
    end
  end
end
