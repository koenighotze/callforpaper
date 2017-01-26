defmodule Callforpapers.Repo.Migrations.CleanupRenaming do
  use Ecto.Migration

  def change do
    drop table(:submissions)
    drop table(:presenters)

    create table(:users) do
      add :name, :string
      add :email, :string
      add :bio, :string
      add :picture, :string

      add :password, :string, virtual: true
      add :password_hash, :string

      add :role, :string, default: "presenter"

      timestamps()
    end

    create table(:submissions) do
      add :title, :string
      add :shortsummary, :string
      add :duration, :integer
      add :externallink, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:submissions, [:user_id])
  end
end
