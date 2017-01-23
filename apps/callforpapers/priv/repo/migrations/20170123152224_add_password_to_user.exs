defmodule Callforpapers.Repo.Migrations.AddPasswordToUser do
  use Ecto.Migration

  def change do
    alter table(:presenters) do
      add :password, :string, virtual: true
      add :password_hash, :string
    end
  end
end
