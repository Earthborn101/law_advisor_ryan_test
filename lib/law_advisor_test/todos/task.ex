defmodule LawAdvisorTest.Todos.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias LawAdvisorTest.Accounts.Users
  alias LawAdvisorTest.Todos.Tasks

  schema "tasks" do
    field :description, :string
    field :order, :integer
    field :status, :boolean, default: false
    field :title, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(task, attrs \\ %{}) do
    task
    |> cast(attrs, [
      :description,
      :order,
      :status,
      :title,
      :user_id
    ])
    |> validate_required([:title, :description, :user_id])
    |> validate_length(:title, max: 25)
  end

  @doc false
  def changeset_update(task, attrs \\ %{}) do
    task
    |> cast(attrs, [
      :description,
      :order,
      :status,
      :title
    ])
    |> validate_length(:title, max: 25)
  end

  @doc false
  def changeset_reorder(task, attrs \\ %{}) do
    task
    |> cast(attrs, [:order, :user_id])
    |> validate_required([:order, :user_id])
    |> validate_order(task)
  end

  defp validate_order(%{valid?: true} = changeset, task) do
    order = fetch_field!(changeset, :order)
    user_id = fetch_field!(changeset, :user_id)

    with true <- Tasks.count_task_by(user_id: user_id) >= order,
         true <- task.order !== order,
         true <- order > 0 do
      changeset
    else
      false ->
        changeset |> add_error(:order, "Invalid order")
    end
  end
end
