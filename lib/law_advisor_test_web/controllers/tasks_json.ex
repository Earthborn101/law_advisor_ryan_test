defmodule LawAdvisorTestWeb.TasksJSON do
  @moduledoc """
  render tasks JSON outputs 
  """
  def list_tasks(%{tasks: tasks}) do
    case Enum.empty?(tasks) do
      true -> []
      false -> Enum.map(tasks, fn task -> remove_struct(task) end)
    end
  end

  def create(%{task: task}), do: remove_struct(task)

  def error(%{error: error}) do
    %{error_message: error}
  end

  def error(template) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  defp remove_struct(attrs) do
    Map.from_struct(attrs) |> Map.delete(:__meta__) |> Map.delete(:user)
  end
end
