defmodule Callforpapers.Repo.Migrations.CreatePresenter do
  use Ecto.Migration

  def change do
    create table(:presenters) do
      add :name, :string
      add :email, :string
      add :bio, :string
      add :picture, :string

      timestamps()
    end

  end
end
