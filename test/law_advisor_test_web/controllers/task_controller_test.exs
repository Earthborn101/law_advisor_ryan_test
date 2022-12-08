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
    test "Fetch List of Tasks", %{conn: conn} do
      assert json_response(post(conn, "/api/tasks"), 200)
    end

    test "Create new Task", %{conn: conn} do
      response = json_response(post(conn, "/api/tasks/create", @create_tasks), 200)

      assert response["description"] == @create_tasks[:description]
      assert response["order"] == 51
      assert response["title"] == @create_tasks[:title]
    end

    test "Update task", %{conn: conn, tasks: tasks} do
      update_task = Enum.fetch!(tasks, 0)

      args = %{
        description: Faker.Lorem.paragraph(2),
        task_id: update_task.id,
        title: Faker.StarWars.En.planet(),
        status: true
      }

      response = json_response(post(conn, "/api/tasks/update", args), 200)

      assert response["description"] == args.description
      assert response["title"] == args.title
      assert response["status"]
    end

    test "Reorder Task order", %{conn: conn, tasks: tasks} do
      task_1 = Enum.fetch!(tasks, 0)
      task_5 = Enum.fetch!(tasks, 4)
      task_10 = Enum.fetch!(tasks, 9)
      task_15 = Enum.fetch!(tasks, 14)
      task_20 = Enum.fetch!(tasks, 19)
      task_25 = Enum.fetch!(tasks, 24)
      task_40 = Enum.fetch!(tasks, 39)

      # Move down task_1 to from order 1 to order 10
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

      # Move down task_1 to from order 10 to order 20
      args = %{
        task_id: task_1.id,
        order: 20
      }

      response = json_response(post(conn, "/api/tasks/reorder", args), 200)
      assert Enum.fetch!(response, 19)["id"] == task_1.id
      assert Enum.fetch!(response, 18)["id"] == task_20.id
      assert Enum.fetch!(response, 18)["order"] == 19
      assert Enum.fetch!(response, 13)["id"] == task_15.id
      assert Enum.fetch!(response, 13)["order"] == 14

      # Move down task_1 to from order 20 to order 40
      args = %{
        task_id: task_1.id,
        order: 40
      }

      response = json_response(post(conn, "/api/tasks/reorder", args), 200)
      assert Enum.fetch!(response, 39)["id"] == task_1.id
      assert Enum.fetch!(response, 38)["id"] == task_40.id
      assert Enum.fetch!(response, 38)["order"] == 39
      assert Enum.fetch!(response, 23)["id"] == task_25.id
      assert Enum.fetch!(response, 23)["order"] == 24

      # Move up task_1 to from order 40 to order 25
      args = %{
        task_id: task_1.id,
        order: 25
      }

      response = json_response(post(conn, "/api/tasks/reorder", args), 200)
      assert Enum.fetch!(response, 24)["id"] == task_1.id
      assert Enum.fetch!(response, 39)["id"] == task_40.id
      assert Enum.fetch!(response, 39)["order"] == 40
      assert Enum.fetch!(response, 23)["id"] == task_25.id
      assert Enum.fetch!(response, 23)["order"] == 24
    end

    test "Delete task", %{conn: conn, tasks: tasks} do
      task_1 = Enum.fetch!(tasks, 0)
      task_2 = Enum.fetch!(tasks, 1)
      task_50 = Enum.fetch!(tasks, 49)

      args = %{
        task_id: Enum.fetch!(tasks, 0).id
      }

      response = json_response(post(conn, "/api/tasks/delete", args), 200)

      refute Enum.fetch!(response, 0)["id"] == task_1.id
      assert Enum.fetch!(response, 0)["id"] == task_2.id

      refute Enum.fetch!(response, 0)["order"] == task_2.order
      assert Enum.fetch!(response, 0)["order"] == 1

      refute Enum.fetch!(response, 48)["order"] == task_50.order
      assert Enum.fetch!(response, 48)["order"] == 49
    end
  end
end
