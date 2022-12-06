defmodule LawAdvisorTest.Repo.Migrations.CreateTasksTable do
  use Ecto.Migration

  def up do
    create table(:tasks) do
      add :description, :text
      add :order, :integer
      add :status, :boolean, default: false
      add :title, :string, size: 25
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end

  def down do
    drop table(:tasks)
  end
end
