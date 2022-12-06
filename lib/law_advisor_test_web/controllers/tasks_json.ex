defmodule LawAdvisorTestWeb.TasksJSON do
  @doc """
  Renders a list of todos.
  """
  def create_task(%{task: task}) do
    %{
      description: task.description,
      id: task.id,
      order: task.order,
      status: task.status,
      title: task.title,
      user_id: task.user_id
    }
  end

  def error(%{error: error}) do
    %{error_message: error}
  end

  def error(template) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
