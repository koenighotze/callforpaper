defmodule Callforpapers.Repo.Migrations.RenameSubmissionTableToTalk do
  use Ecto.Migration

  def change do
    # drop contraints
    drop_if_exists index(:filings, [:submission_id, :cfp_id])
    drop_if_exists index(:filings, :submission_id)
    drop constraint(:filings, :filings_submission_id_fkey)

    # rename table
    rename table(:submissions), to: table(:talks)
    rename table(:filings), :submission_id, to: :talk_id

    # recreate constraints
    create unique_index(:filings, [:talk_id, :cfp_id])
    create unique_index(:filings, :talk_id)

    alter table(:filings) do
      modify :talk_id, references(:talks, on_delete: :nothing)
    end
  end
end
