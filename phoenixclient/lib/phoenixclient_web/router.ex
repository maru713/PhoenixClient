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
    get "/", PageController, :index

    get "/search", SearchController, :search#検索
    get "/locsearch", SearchController, :locsearch#検索

    resources "/users", UserController #usersパスへのすべてのリクエストを許可
    get "/userdata", UserController, :get_user # ユーザーのデータ取得

    resources "/locations", LocationController#位置登録

    post "/auth", LoginController, :auth # トークン認証のためのリクエスト
    post "/login", LoginController, :login #loginのための情報送信
    post "/logout", LoginController, :logout
    post "/refresh_token", LoginController, :refresh_token #アクセストークン再発行のルーティング

    post "/relations", RelationController, :add #フレンド追加
    get "/relations", RelationController, :index
    post "/accept", RelationController, :accept
    get "/incoming", RelationController, :incoming
  end

  # scope "/", PhoenixclientWeb do
  # pipe_through [:browser, :auth, :ensure_auth]


  # Other scopes may use custom stacks.
  # scope "/api", PhoenixclientWeb do
  #   pipe_through :api
  # end
end
