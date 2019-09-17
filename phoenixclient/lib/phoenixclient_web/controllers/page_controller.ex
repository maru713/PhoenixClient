defmodule PhoenixclientWeb.PageController do
  use PhoenixclientWeb, :controller

  def index(conn, _params) do
    
    json(conn, %{message: "Success!"})
  end
end
