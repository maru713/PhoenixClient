defmodule PhoenixclientWeb.LoginController do
  use PhoenixclientWeb, :controller

  alias Phoenixclient.Accounts.User
  alias Phoenixclient.Accounts
  alias Phoenixclient.Accounts.Guardian
  alias Phoenixclient.Accounts.AuthTokens

  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    |>IO.inspect(label: "DEBUGDESU")
      json(conn, %{message: "Success!"})
  end

  def login(conn) do
    email = Map.get(conn.params, "email")
    password = Map.get(conn.params,"password")
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

  defp create_token(user) do
    {:ok, access_token, access_claims} = Guardian.encode_and_sign(user, %{}, [token_type: "access", ttl: {1, :weeks}])
    {:ok, refresh_token, refresh_claims} = Guardian.encode_and_sign(user, %{access_token: access_token}, [token_type: "refresh", ttl: {4, :weeks}])
    {:ok, _a_token} = AuthTokens.after_encode_and_sign(user, access_claims, access_token)
    {:ok, _r_token} = AuthTokens.after_encode_and_sign(user, refresh_claims, refresh_token)
    {:ok, access_token, access_claims, refresh_token, refresh_claims}
  end
end