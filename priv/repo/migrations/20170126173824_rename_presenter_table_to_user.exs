defmodule Callforpapers.Repo.Migrations.RenamePresenterTableToUser do
  use Ecto.Migration

  def change do
    # rename table(:presenters), :presenter_id, to: :user_id

    drop_if_exists index(:submissions, [:presenter_id])
    rename table(:submissions), :presenter_id, to: :user_id
    alter table(:submissions) do
      modify :user_id, references(:presenters, on_delete: :delete_all)
    end


  end
end
