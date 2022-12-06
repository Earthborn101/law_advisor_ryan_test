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

[user1, user2]
|> Enum.map(fn user ->
  LawAdvisorTest.Accounts.Users.create_user(user)
end)
