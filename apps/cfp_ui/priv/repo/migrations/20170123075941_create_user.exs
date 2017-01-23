defmodule CfpUi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :bio, :string
      add :profile, :string

      timestamps()
    end

  end
end
