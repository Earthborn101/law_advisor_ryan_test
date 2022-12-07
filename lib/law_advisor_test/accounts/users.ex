defmodule LawAdvisorTest.Accounts.Users do
  @moduledoc """
  The users context.
  """

  import Ecto.Query, warn: false

  alias LawAdvisorTest.Repo
  alias LawAdvisorTest.Accounts.Auth
  alias LawAdvisorTest.Accounts.User

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{"username" => "username1", "password" => "12345"})
      {:ok, %User{}}

      iex> create_user(%{"username" => "username1", "password" => "123456"})
      {:error, changeset}
  """
  def create_user(params) do
    User.changeset(%User{}, params)
    |> Auth.hash_password()
    |> Repo.insert()
  end
end
