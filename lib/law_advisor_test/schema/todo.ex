defmodule LawAdvisorTest.Schema.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :title, :string
    field :description, :string
    field :order, :integer
    field :status, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :order, :status])
    |> validate_required([:title, :status])
  end
end
