defmodule PhoenixclientWeb.LoginController do
    use PhoenixclientWeb, :controller

    alias Phoenixclient.Accounts
    alias Phoenixclient.Accounts.Guardian
    alias Phoenixclient.Auth.AuthTokens

  def index(conn, _params) do
    user =
      case Accounts.current_user(conn) do
          true -> Accounts.current_user(conn).name
          nil -> "not logged in"
      end
    json(conn, %{message: user})
  end
  def login(conn,_) do
    email = Map.get(conn.params, "email")
    password = Map.get(conn.params,"password")
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end
  defp login_reply({:error, _error}, conn) do
    json(conn, %{message: "login failed!"})
  end
  defp login_reply({:ok, user}, conn) do

    {:ok, access_token, access_claims, refresh_token, _refresh_claims} = create_token(user)

    conn
    |> Guardian.Plug.sign_in(user)
    
    response = %{
      access_token: access_token,
      refresh_token: refresh_token,
      expires_in: access_claims["exp"]
    }
    render(conn, "login.json", response: response)
  end

  defp create_token(user) do
    {:ok, access_token, access_claims} = Guardian.encode_and_sign(user, %{}, [token_type: "access", ttl: {1, :weeks}])
    {:ok, refresh_token, refresh_claims} = Guardian.encode_and_sign(user, %{access_token: access_token}, [token_type: "refresh", ttl: {4, :weeks}])
    {:ok, _a_token} = AuthTokens.after_encode_and_sign(user, access_claims, access_token)
    {:ok, _r_token} = AuthTokens.after_encode_and_sign(user, refresh_claims, refresh_token)
    {:ok, access_token, access_claims, refresh_token, refresh_claims}
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end