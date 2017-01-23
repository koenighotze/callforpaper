defmodule Callforpapers.Repo.Migrations.CreateSubmission do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :title, :string
      add :shortsummary, :string
      add :duration, :integer
      add :externallink, :string
      add :presenter_id, references(:presenters, on_delete: :nothing)

      timestamps()
    end
    create index(:submissions, [:presenter_id])

  end
end
