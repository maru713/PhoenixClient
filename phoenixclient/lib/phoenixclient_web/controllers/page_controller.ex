defmodule PhoenixclientWeb.PageController do
  use PhoenixclientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
