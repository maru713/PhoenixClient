defmodule PhoenixclientWeb.LocationController do
  use PhoenixclientWeb, :controller

  alias Phoenixclient.Locations
  alias Phoenixclient.Locations.Location

  action_fallback PhoenixclientWeb.FallbackController

  def index(conn, _params) do
    locations = Locations.list_locations()
    render(conn, "index.json", locations: locations)
  end

  def create(conn, _params) do
    IO.inspect(conn.params)
    location_params =
      %{"longitude" => conn.params["longitude"],"latitude" => conn.params["latitude"],"userid" => conn.params["userid"],"place" => conn.params["place"]}
      |>IO.inspect
    with {:ok, %Location{} = location} <- Locations.create_location(location_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.location_path(conn, :show, location))
      |> render("show.json", location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = Locations.get_location!(id)
    render(conn, "show.json", location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = Locations.get_location!(id)

    with {:ok, %Location{} = location} <- Locations.update_location(location, location_params) do
      render(conn, "show.json", location: location)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = Locations.get_location!(id)

    with {:ok, %Location{}} <- Locations.delete_location(location) do
      send_resp(conn, :no_content, "")
    end
  end
end
