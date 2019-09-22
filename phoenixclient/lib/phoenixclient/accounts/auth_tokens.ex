defmodule Phoenixclient.Accounts.AuthTokens do
    use Guardian, otp_app: :app_ex

    # トークンをDBに追加する関数
    def after_encode_and_sign(resource, claims, token) do
        with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
            {:ok, token}
        end
    end

    # トークンの確認を行う関数
    def on_verify(claims, token) do
        with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
            {:ok, claims}
        end
    end

    # トークンの破棄を行う関数
    def on_revoke(claims, token) do
        with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
            {:ok, claims}
        end
    end
end