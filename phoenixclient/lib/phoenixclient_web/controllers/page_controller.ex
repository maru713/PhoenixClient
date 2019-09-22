defmodule PhoenixclientWeb.PageController do
  use PhoenixclientWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn)
    json(conn, %{message: "kaere"})
  end
end
