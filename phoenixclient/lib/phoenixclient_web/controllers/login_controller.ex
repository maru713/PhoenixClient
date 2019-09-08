defmodule PhoenixclientWeb.LoginController do
    use PhoenixclientWeb, :controller

    alias Phoenixclient.Accounts.User
    alias Phoenixclient.Accounts
    alias Phoenixclient.Accounts.Guardian

  def index(conn, _params) do
  changeset = Accounts.change_user(%User{})
    render(conn, "index.html",changeset: changeset)
  end
  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end
   defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: Routes.login_path(conn, :index))
  end
  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end
   def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logout successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end