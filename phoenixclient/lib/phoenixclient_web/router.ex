defmodule PhoenixclientWeb.Router do
  use PhoenixclientWeb, :router
  alias Routes

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

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
    pipe_through [:browser, :api, :auth]
    
    delete "/logout", LoginController, :delete
    get "/", PageController, :index
    
    get "/login", LoginController, :index   #login画面を表示
  end
  scope "/", PhoenixclientWeb do
    pipe_through [:api, :auth]
    post "/add", RelationController, :add #フレンド申請
    post "/search", SearchController, :search#検索
    resources "/users", UserController #usersパスへのすべてのリクエストを許可
    resources "/locations", LocationController#位置登録
    post "/login", LoginController, :login #loginのための情報送信
  end
  scope "/", PhoenixclientWeb do
  pipe_through [:browser, :auth, :ensure_auth]

  get "/incoming", RelationController, :incoming
    post "/incoming", RelationController, :accept
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixclientWeb do
  #   pipe_through :api
  # end
end
