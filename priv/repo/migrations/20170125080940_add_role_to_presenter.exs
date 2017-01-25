defmodule Callforpapers.Repo.Migrations.AddRoleToPresenter do
  use Ecto.Migration

  def change do
    alter table(:presenters) do
      add :role, :string, default: "presenter"
    end
  end
end
