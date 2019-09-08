defmodule Phoenixclient.Repo.Migrations.CreateRelation do
  use Ecto.Migration

  def change do
    create table(:relation) do
      add :sourceID, :integer
      add :destinationID, :integer
      add :status, :boolean, default: false, null: false

      timestamps()
    end

  end
end
