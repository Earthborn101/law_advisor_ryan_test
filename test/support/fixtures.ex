defmodule LawAdvisorTestWeb.Fixtures do
  @moduledoc """
  Shared fixtures for test
  """

  use LawAdvisorTestWeb.ConnCase

  alias LawAdvisorTestWeb.Guardian
  alias LawAdvisorTestWeb.TasksFixtures
  alias LawAdvisorTestWeb.UsersFixtures

  def fixture(conn) do
    user = UsersFixtures.fixture(:users)
    tasks = TasksFixtures.fixture(:tasks, user)

    %{
      tasks: tasks,
      user: user,
      conn: secure_conn(user, conn)
    }
  end

  defp secure_conn(user, conn) do
    {:ok, jwt, _} = user |> Guardian.encode_and_sign(%{}, token_type: :token)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> jwt)
  end
end
