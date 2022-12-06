defmodule LawAdvisorTest.Todos.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias LawAdvisorTest.Accounts.User

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
  end
end
