defmodule LawAdvisorTestWeb.TasksController do
  use LawAdvisorTestWeb, :controller
  use LawAdvisorTestWeb.GuardedController

  alias LawAdvisorTest.Todos.Tasks

  plug(Guardian.Plug.EnsureAuthenticated when action in [:index, :create])

  def index(conn, _params, current_user) do
    render(conn, "list_tasks.json", tasks: Tasks.list_tasks_by_user_id(current_user.id))
  end

  def create(conn, params, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    case Tasks.create_task(params) do
      {:ok, task} ->
        render(conn, "create_or_update.json", task: task)

      {:error, _} ->
        render(conn, "error.json", error: "Invalid Task")
    end
  end

  def update(conn, params, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    case Tasks.update_task(params) do
      {:ok, task} ->
        render(conn, "create_or_update.json", task: task)

      {:error, _} ->
        render(conn, "error.json", error: "Invalid Task Parameters")
    end
  end

  def delete(conn, params, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    case Tasks.delete_task(params) do
      {:ok, %{tasks: tasks}} ->
        render(conn, "list_tasks.json", tasks: tasks)

      {:error, _} ->
        render(conn, "error.json", error: "Invalid Task Parameters")
    end
  end

  def reorder_tasks(conn, params, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    case Tasks.reorder_tasks(params) do
      {:ok, %{tasks: tasks}} ->
        render(conn, "list_tasks.json", tasks: tasks)

      _ ->
        render(conn, "error.json", error: "Invalid Params")
    end
  end
end
