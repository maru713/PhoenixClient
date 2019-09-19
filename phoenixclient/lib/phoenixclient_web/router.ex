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

'''
  scope "/", PhoenixclientWeb do
    pipe_through [:browser, :api, :auth]

    post "/login", LoginController, :login #loginのための情報送信
    post "/add", RelationController, :add #フレンド申請
    delete "/logout", LoginController, :delete
    get "/", PageController, :index

    get "/login", LoginController, :index   #login画面を表示
  end
'''

  scope "/", PhoenixclientWeb do
    pipe_through :api

    post "/search", SearchController, :search#検索
    post "/accept", RelationController, :accept
    resources "/users", UserController #usersパスへのすべてのリクエストを許可
    resources "/locations", LocationController#位置登録
    post "/auth", LoginController, :auth # トークン認証のためのリクエスト
    post "/login", LoginController, :login #loginのための情報送信
    post "/logout", LoginController, :logout
    post "/refresh_token", LoginController, :refresh_token #アクセストークン再発行のルーティング
  end

  # scope "/", PhoenixclientWeb do
  # pipe_through [:browser, :auth, :ensure_auth]


  # Other scopes may use custom stacks.
  # scope "/api", PhoenixclientWeb do
  #   pipe_through :api
  # end
end
