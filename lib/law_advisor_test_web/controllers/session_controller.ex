defmodule LawAdvisorTestWeb.SessionController do
  use LawAdvisorTestWeb, :controller
  use LawAdvisorTestWeb.GuardedController

  alias LawAdvisorTest.Accounts.Auth

  def create(conn, params, _) do
    case Auth.login(params) do
      {:ok, user} ->
        {:ok, jwt, _} = LawAdvisorTestWeb.Guardian.encode_and_sign(user, %{}, token_type: :token)

        conn
        |> put_status(:created)
        |> render("login.json", jwt: jwt, user: user)

      {:error, _} ->
        conn
        |> put_status(401)
        |> render("error.json", error: "Invalid username or password")
    end
  end

  def delete(conn, _params, _) do
    conn
    |> delete_session(:current_user)
    |> put_status(200)
    |> render("logout.json", message: "Logout successfully")
  end

  def auth_error(conn, _, _opts) do
    conn
    |> put_status(:forbidden)
    |> render("error.json", message: "Not Authenticated")
  end
end
