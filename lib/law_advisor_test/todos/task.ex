defmodule LawAdvisorTest.Todos.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias LawAdvisorTest.Accounts.Users
  alias LawAdvisorTest.Todos.Tasks

  schema "tasks" do
    field :description, :string
    field :order, :integer
    field :status, :boolean
    field :title, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :description,
      :order,
      :status,
      :title,
      :title,
      :user_id
    ])
    |> validate_required([:title, :description])
    |> put_order()
  end

  defp put_order(changeset) do
    user_id = fetch_field!(changeset, :user_id)

    changeset
    |> put_change(:order, Tasks.count_task_by_user_id(user_id) + 1)
  end
end
