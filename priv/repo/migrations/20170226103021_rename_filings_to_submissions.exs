defmodule Callforpapers.Repo.Migrations.RenameFilingsToSubmissions do
  use Ecto.Migration

  def change do
    rename table(:filings), to: table(:submissions)
  end
end
