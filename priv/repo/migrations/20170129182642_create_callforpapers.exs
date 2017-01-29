defmodule Callforpapers.Repo.Migrations.CreateCallforpapers do
  use Ecto.Migration

  def change do
    drop_if_exists table(:callforpapers)

    create table(:callforpapers) do
      add :start, :date
      add :end, :date
      add :status, :string
      add :conference_id, references(:conferences, on_delete: :nothing)

      timestamps()
    end
    create index(:callforpapers, [:conference_id])

  end
end
