defmodule PhoenixclientWeb.RelationView do
  use PhoenixclientWeb, :view
  alias PhoenixclientWeb.RelationView
  def render("index.json", %{relation: relation}) do
    %{data: render_many(relation, RelationView, "relation.json")}
  end

  def render("show.json", %{relation: relation}) do
    %{data: render_one(relation, RelationView, "relation.json")}
  end

  def render("relation.json", %{relation: relation}) do
    %{sourceID: relation.sourceID,
      destinationID: relation.destinationID,
      status: relation.status}
  end
end
