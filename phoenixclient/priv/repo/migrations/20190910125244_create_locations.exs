defmodule Phoenixclient.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :longitude, :float
      add :latitude, :float
      add :userid, :integer
      add :place, :string

      timestamps()
    end

  end
end
