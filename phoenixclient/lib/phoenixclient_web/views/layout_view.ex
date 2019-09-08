defmodule PhoenixclientWeb.LayoutView do
  use PhoenixclientWeb, :view
  alias Phoenixclient.Accounts.Guardian
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
