defmodule CfpUi.Repo.Migrations.CreateRating do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :presentation_id, references(:presentations, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:ratings, [:presentation_id])
    create index(:ratings, [:user_id])

  end
end
