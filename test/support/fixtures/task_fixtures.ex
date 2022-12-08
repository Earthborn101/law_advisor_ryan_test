defmodule LawAdvisorTestWeb.TasksFixtures do
  @moduledoc """
  Fixtures for tasks
  """

  alias LawAdvisorTest.Todos.Tasks

  def fixture(:tasks, attrs \\ %{}) do
    Map.new()
    |> List.duplicate(50)
    |> Enum.map(fn params ->
      {:ok, task} = Tasks.create_task(task_attrs(params, attrs))

      task
    end)
  end

  defp task_attrs(params, attrs) do
    params
    |> Map.put(:description, Faker.Lorem.paragraph(2))
    |> Map.put(:title, Faker.StarWars.En.planet())
    |> Map.put(:user_id, attrs.id)
  end
end
