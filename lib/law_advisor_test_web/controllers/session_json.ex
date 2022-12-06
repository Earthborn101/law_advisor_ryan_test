defmodule LawAdvisorTestWeb.SessionJSON do
  @doc """
  Renders login credentials.
  """
  def login(%{jwt: jwt, user: user}) do
    %{username: user.username, token: jwt}
  end

  def error(%{error: error}) do
    %{error_message: error}
  end

  def logout(%{message: message}) do
    %{message: message}
  end
end
