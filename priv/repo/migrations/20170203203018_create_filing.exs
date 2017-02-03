defmodule Callforpapers.Repo.Migrations.CreateFiling do
  use Ecto.Migration

  def change do
    create table(:filings) do
      add :status, :string
      add :submission_id, references(:submissions, on_delete: :nothing)
      add :cfp_id, references(:callforpapers, on_delete: :nothing)

      timestamps()
    end
    create index(:filings, [:submission_id])
    create index(:filings, [:cfp_id])

  end
end
