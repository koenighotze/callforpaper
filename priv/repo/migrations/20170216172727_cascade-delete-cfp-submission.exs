defmodule :"Elixir.Callforpapers.Repo.Migrations.Cascade-delete-cfp-submission" do
  use Ecto.Migration

  def change do
    drop constraint(:filings, :filings_cfp_id_fkey)
    drop_if_exists index(:callforpapers, [:cfp_id])
    alter table(:filings) do
      modify :cfp_id, references(:callforpapers, on_delete: :delete_all)
    end
  end
end
