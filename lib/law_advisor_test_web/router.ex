defmodule LawAdvisorTestWeb.Router do
  use LawAdvisorTestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LawAdvisorTestWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug(
      Guardian.Plug.Pipeline,
      error_handler: LawAdvisorTestWeb.SessionController,
      module: LawAdvisorTestWeb.Guardian
    )

    plug(Guardian.Plug.VerifyHeader, scheme: "Bearer")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  # Other scopes may use custom stacks.
  scope "/api", LawAdvisorTestWeb do
    pipe_through :api

    post "/login", SessionController, :create

    scope "/tasks" do
      post "/", TasksController, :index
      post "/create", TasksController, :create
      post "/reorder", TasksController, :reorder_tasks
    end
  end
end
