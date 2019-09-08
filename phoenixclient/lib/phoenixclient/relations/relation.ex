defmodule Phoenixclient.Relations.Relation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "relation" do
    field :destinationID, :integer
    field :sourceID, :integer
    field :status, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(relation, attrs) do
    relation
    |> cast(attrs, [:sourceID, :destinationID, :status])
    |> validate_required([:sourceID, :destinationID, :status])
  end
end
