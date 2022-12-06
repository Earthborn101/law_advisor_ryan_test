defmodule LawAdvisorTest.Accounts.Auth do
  @moduledoc """
  The boundry for the Auth system
  """

  import Ecto.{Query, Changeset}, warn: false

  alias Comeonin.Bcrypt
  alias LawAdvisorTest.Repo
  alias LawAdvisorTest.Accounts.User

  def login(%{"username" => username, "password" => password}) do
    user = Repo.get_by(User, username: username)

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, "Could not login"}
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Bcrypt.checkpw(password, user.password_hash)
    end
  end

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Repo.get(User, id)
  end

  def logged_in?(conn), do: !!current_user(conn)
end
