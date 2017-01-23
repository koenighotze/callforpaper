defmodule CfpUi.Repo.Migrations.CreateSubmission do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :title, :string
      add :short_description, :string
      add :reference, :string
      add :duration_minutes, :integer

      timestamps()
    end

  end
end
