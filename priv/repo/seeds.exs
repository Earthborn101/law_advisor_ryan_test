# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LawAdvisorTest.Repo.insert!(%LawAdvisorTest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

user1 = %{
  username: "user1",
  password: "12345"
}

user2 = %{
  username: "user2",
  password: "12345"
}

{:ok, user1} = LawAdvisorTest.Accounts.Users.create_user(user1)
{:ok, user2} = LawAdvisorTest.Accounts.Users.create_user(user2)

Map.new()
|> List.duplicate(50)
|> Enum.with_index()
|> Enum.map(fn {params, index} ->
  LawAdvisorTest.Todos.Tasks.create_task(
    params
    |> Map.put(:description, "desc user1 #{index}")
    |> Map.put(:title, "title user1 #{index}")
    |> Map.put(:user_id, user1.id)
  )
end)

Map.new()
|> List.duplicate(50)
|> Enum.with_index()
|> Enum.map(fn {params, index} ->
  LawAdvisorTest.Todos.Tasks.create_task(
    params
    |> Map.put(:description, "desc user2 #{index}")
    |> Map.put(:title, "title user2 #{index}")
    |> Map.put(:user_id, user2.id)
  )
end)
