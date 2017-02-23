defmodule Callforpapers.Repo.Migrations.ConferenceOneToOneCfp do
  use Ecto.Migration

  def up do
    drop_if_exists index(:callforpapers, :conference_id)
    create unique_index(:callforpapers, :conference_id)
  end

  def down do
    drop_if_exists index(:callforpapers, :conference_id)
  end
end
