defmodule Callforpapers.Repo.Migrations.CreateConference do
  use Ecto.Migration

  def change do
    create table(:conferences) do
      add :title, :string
      add :start, :date
      add :end, :date

      timestamps()
    end

  end
end
