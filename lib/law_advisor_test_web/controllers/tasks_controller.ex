defmodule LawAdvisorTestWeb.TasksController do
  use LawAdvisorTestWeb, :controller

  alias LawAdvisorTest.Todos.Tasks

  plug(Guardian.Plug.EnsureAuthenticated when action in [:create])

  def create(conn, params) do
    case Tasks.create_task(params) do
      {:ok, task} ->
        render(conn, "create_task.json", task: task)

      {:error, _} ->
        render(conn, "error.json", "Invalid Task")
    end
  end
end
