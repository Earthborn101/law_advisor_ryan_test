defmodule LawAdvisorTestWeb.TaskControllerTest do
  use LawAdvisorTestWeb.ConnCase

  import LawAdvisorTestWeb.Fixtures

  @create_tasks %{
    description: Faker.Lorem.paragraph(2),
    title: Faker.StarWars.En.planet()
  }

  setup %{conn: conn} do
    {:ok, fixture(conn)}
  end

  describe "As a User, " do
    test "Fetch List of Users", %{conn: conn} do
      assert json_response(post(conn, "/api/tasks"), 200)
    end

    test "Create new Task", %{conn: conn} do
      response = json_response(post(conn, "/api/tasks/create", @create_tasks), 200)

      assert response["description"] == @create_tasks[:description]
      assert response["order"] == 51
      assert response["title"] == @create_tasks[:title]
    end

    test "Reorder Task List", %{conn: conn, tasks: tasks} do
      task_1 = Enum.fetch!(tasks, 0)
      task_5 = Enum.fetch!(tasks, 4)
      task_10 = Enum.fetch!(tasks, 9)
      task_20 = Enum.fetch!(tasks, 19)
      task_25 = Enum.fetch!(tasks, 24)
      task_40 = Enum.fetch!(tasks,39)

      args = %{
        task_id: task_1.id,
        order: 10
      }

      response = json_response(post(conn, "/api/tasks/reorder", args), 200)
      assert Enum.fetch!(response, 9)["id"] == task_1.id
      assert Enum.fetch!(response, 8)["id"] == task_10.id
      assert Enum.fetch!(response, 8)["order"] == 9
      assert Enum.fetch!(response, 3)["id"] == task_5.id
      assert Enum.fetch!(response, 3)["order"] == 4

      # response = json_response(post(conn, "/api/tasks/reorder", args), 200)
    end
  end
end
