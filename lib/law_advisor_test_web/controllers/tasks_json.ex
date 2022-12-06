defmodule LawAdvisorTestWeb.TasksJSON do
  @doc """
  Renders a list of todos.
  """
  def create_task(%{tasks: tasks}) do
    %{data: tasks}
  end
end
