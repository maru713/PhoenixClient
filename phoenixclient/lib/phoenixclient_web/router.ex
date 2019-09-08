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

  pipeline :auth do
    plug Phoenixclient.Accounts.Pipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixclientWeb do
    pipe_through [:browser, :auth]

    resources "/users", UserController #usersパスへのすべてのリクエストを許可
    get "/", PageController, :index
    get "/login", LoginController, :index   #login画面を表示
    post "/login", LoginController, :login #loginのための情報送信  
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixclientWeb do
  #   pipe_through :api
  # end
end
