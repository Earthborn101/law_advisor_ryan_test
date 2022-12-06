defmodule LawAdvisorTest.Todos.Tasks do
  @moduledoc """
  The tasks context.
  """

  import Ecto.Query, warn: false

  alias LawAdvisorTest.Repo
  alias LawAdvisorTest.Todos.Task

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{"title" => "Sample Tasks", "description" => "Sample description"})
      %{
        title: "Sample Tasks",
        description: "Sample description"
      }

  """
  def create_task(params) do
    Task.changeset(%Task{}, params) |> Repo.insert()
  end

  def count_task_by_user_id(user_id) do
    query = from(t in Task, where: t.user_id == ^user_id)

    Repo.aggregate(query, :count)
  end
end
