defmodule Phoenixclient.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :latitude, :float
    field :longitude, :float
    field :place, :string
    field :userid, :integer

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:longitude, :latitude, :userid, :place])
    |> validate_required([:longitude, :latitude, :userid, :place])
  end
end
