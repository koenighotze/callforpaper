defmodule Callforpapers.Repo.Migrations.AddRelationConferenceToUser do
  use Ecto.Migration

  def change do
    alter table(:conferences) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
