defmodule LawAdvisorTest.Repo.Migrations.CreateTodosTable do
  use Ecto.Migration

  def up do
    create table(:todos) do
      add :title, :string, size: 25
      add :description, :text
      add :order, :integer
      add :status, :boolean, default: false

      timestamps()
    end
  end

  def down do
    drop table(:todos)
  end
end
