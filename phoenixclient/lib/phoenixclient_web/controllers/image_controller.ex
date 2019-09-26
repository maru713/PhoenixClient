defmodule PhoenixclientWeb.ImageController do
  use PhoenixclientWeb, :controller

  def upload(conn, _params) do
    image =conn.params["image"]
    upload =
    IO.inspect(image.path)
    |>Cloudex.upload()
    |>IO.inspect()
    |>elem(1)
    IO.inspect(upload.url)
    json(conn, %{message: "Success!"})
  end
end
