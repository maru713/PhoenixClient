defmodule PhoenixclientWeb.Router do
  use PhoenixclientWeb, :router
  alias Routes

  pipeline :auth do #ログイン認証のためのパイプライン
    plug Phoenixclient.Accounts.Pipeline
  end

  pipeline :ensure_auth do  #ログイン済みであるかの判断のためのパイプライン
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixclientWeb do
    pipe_through [:api, :auth]
    get "/relation", RelationController, :index #フレンド申請
    post "/add", RelationController, :add #フレンド申請
    post "/search", SearchController, :search#検索
    post "/accept", RelationController, :accept
    resources "/users", UserController #usersパスへのすべてのリクエストを許可
    resources "/locations", LocationController#位置登録
    post "/login", LoginController, :login #loginのための情報送信
    delete "/logout", LoginController, :delete
    get "/", PageController, :index
    post "/locsearch", SearchController, :locsearch #location検索
  end


  # Other scopes may use custom stacks.
  # scope "/api", PhoenixclientWeb do
  #   pipe_through :api
  # end
end
