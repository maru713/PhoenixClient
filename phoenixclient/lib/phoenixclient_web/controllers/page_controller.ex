defmodule PhoenixclientWeb.PageController do
  use PhoenixclientWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn.params)
    json(conn, %{message: conn.params["word"]})
  end
end
