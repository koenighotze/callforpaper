defmodule CfpUi.Repo.Migrations.CreatePresentation do
  use Ecto.Migration

  def change do
    create table(:presentations) do
      add :held_at, :datetime
      add :held_where, :string

      timestamps()
    end

  end
end
