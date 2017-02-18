defmodule Callforpapers.Repo.Migrations.ConferenceTitleIsUnique do
  use Ecto.Migration

  def change do
    create index(:conferences, :title, unique: true)
  end
end
