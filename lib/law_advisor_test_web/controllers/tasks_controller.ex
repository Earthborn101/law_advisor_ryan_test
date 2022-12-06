defmodule LawAdvisorTestWeb.TasksController do
  use LawAdvisorTestWeb, :controller
  use LawAdvisorTestWeb.GuardedController

  alias LawAdvisorTest.Todos.Tasks

  plug(Guardian.Plug.EnsureAuthenticated when action in [:create])

  def create(conn, params, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    case Tasks.create_task(params) do
      {:ok, task} ->
        render(conn, "create_task.json", task: task)

      {:error, _} ->
        render(conn, "error.json", error: "Invalid Task")
    end
  end
end
