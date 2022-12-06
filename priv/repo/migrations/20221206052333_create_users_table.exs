defmodule LawAdvisorTest.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :username, :string, size: 25
      add :password_hash, :string

      timestamps()
    end
  end

  def down do
    drop table(:users)
  end
end
