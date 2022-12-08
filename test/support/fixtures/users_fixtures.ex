defmodule LawAdvisorTestWeb.UsersFixtures do
  @moduledoc """
  Fixtures for Users
  """

  alias LawAdvisorTest.Accounts.Users
  alias LawAdvisorTestWeb.Guardian

  @user_attrs %{
    username: "john",
    password: "some password"
  }

  def fixture(:users) do
    {:ok, user} = Users.create_user(@user_attrs)

    user
  end
end
