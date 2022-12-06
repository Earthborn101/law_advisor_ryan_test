defmodule LawAdvisorTest.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias LawAdvisorTest.Todos.Task

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :task, Task

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> validate_length(:password, min: 5)
  end
end
