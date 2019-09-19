defmodule PhoenixclientWeb.LoginController do
  use PhoenixclientWeb, :controller

  alias Phoenixclient.Accounts.User
  alias Phoenixclient.Accounts
  alias Phoenixclient.Accounts.Guardian
  alias Phoenixclient.Accounts.AuthTokens

'''
  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    |>IO.inspect(label: "DEBUGDESU")
      json(conn, %{message: "Success!"})
  end

  def login(conn, _) do
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

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end
'''

  # クライアントが最初に送信するトークンの認証
  def auth(conn, %{"access_token"=>access_token}) do
    conn
    |> auth_reply(confirm_token(access_token))
  end

  def login(conn, %{"user"=>%{"email"=>email, "password"=>plain_text_password}}) do
    conn
    |> login_reply(Accounts.authenticate_user(email, plain_text_password))
  end

  # リフレッシュトークンに基づいたアクセストークンを削除する
  def logout(conn, %{"refresh_token" => refresh_token}) do
    logout_reply(conn, confirm_token(refresh_token), refresh_token)
  end

  defp auth_reply(conn, {:ok, claims}) do
    user = Accounts.get_user!(claims["sub"])
    response = %{
      user: user
    }
    render(conn, "auth.json", response: response)
  end
  defp auth_reply(conn, {:error, _}) do
    response = %{}
    conn
    |> put_status(:bad_request)
    |> render("auth-error.json", response: response)
  end

  defp login_reply(conn, {:ok, user}) do
    {:ok, access_token, access_claims, refresh_token, _refresh_claims} = create_token(user)
    response = %{
      access_token: access_token,
      refresh_token: refresh_token,
      expires_in: access_claims["exp"]
    }
    render(conn, "login.json", response: response)
  end
  defp login_reply(conn, {:error, _}) do
    response = %{}
    conn
    |> put_status(:unauthorized)
    |> render("login-error.json", response: response)
  end

  defp logout_reply(conn, {:ok, claims}, refresh_token) do
    case AuthTokens.on_revoke(claims, refresh_token) do
      {:ok, _} ->
        with {:ok, access_claims} <- confirm_token(claims["access_token"]) do
          AuthTokens.on_revoke(access_claims, claims["access_token"])
        end
        render(conn, "logout.json", response: %{})
      {:error, _} -> logout_reply(conn, {:error, :revoke_error}, refresh_token)
    end
  end
  defp logout_reply(conn, {:error, _}, _) do
    conn
    |> put_status(:bad_request)
    |> render("logout-error.json", response: %{})
  end

  def confirm_token(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        AuthTokens.on_verify(claims, token)
      _ -> {:error, :not_decode_and_verify}
    end
  end

  defp create_token(user) do
    {:ok, access_token, access_claims} = Guardian.encode_and_sign(user, %{}, [token_type: "access", ttl: {1, :weeks}])
    {:ok, refresh_token, refresh_claims} = Guardian.encode_and_sign(user, %{access_token: access_token}, [token_type: "refresh", ttl: {4, :weeks}])
    {:ok, _a_token} = AuthTokens.after_encode_and_sign(user, access_claims, access_token)
    {:ok, _r_token} = AuthTokens.after_encode_and_sign(user, refresh_claims, refresh_token)
    {:ok, access_token, access_claims, refresh_token, refresh_claims}
  end

  def refresh_token(conn, %{"refresh_token"=>refresh_token}) do
    refresh_token_reply(conn, confirm_token(refresh_token), refresh_token)
  end

  defp refresh_token_reply(conn, {:ok, claims}, refresh_token) do
    user = Accounts.get_user!(claims["sub"])
    AuthTokens.on_revoke(claims, refresh_token)
    with {:ok, access_claims} <- confirm_token(claims["access_token"]) do
      AuthTokens.on_revoke(access_claims, claims["access_token"])
    end
    login_reply(conn, {:ok, user})
  end

  defp refresh_token_reply(conn, {:error, _}, _) do
    conn
    |> put_status(:bad_request)
    |> render("expired.json", response: %{})
  end
end