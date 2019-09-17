defmodule PhoenixclientWeb.LocationView do
  use PhoenixclientWeb, :view
  alias PhoenixclientWeb.LocationView

  def render("index.json", %{locations: locations}) do
    %{data: render_many(locations, LocationView, "location.json")}
  end

  def render("show.json", %{location: location}) do
    %{data: render_one(location, LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{id: location.id,
      longitude: location.longitude,
      latitude: location.latitude,
      userid: location.userid,
      place: location.place}
  end
end
