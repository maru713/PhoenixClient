defmodule PhoenixclientWeb.LayoutView do
  use PhoenixclientWeb, :view
  alias ExBlog.Accounts.Guardian
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
