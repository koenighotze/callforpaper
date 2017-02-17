defmodule Callforpapers.Repo.Migrations.AddUniqueConstraintSubmissionTalkCfp do
  use Ecto.Migration

  def change do
    create index(:filings, [:submission_id, :cfp_id], unique: true)
  end
end
