defmodule PhoenixclientWeb.SearchController do
    use PhoenixclientWeb, :controller

    action_fallback PhoenixclientWeb.FallbackController
    alias Phoenixclient.Accounts
    alias PhoenixclientWeb.ResultView

    def search(conn,_) do
        result = 
            conn.params["searchtmp"]
            |>Accounts.searchName()
        json(conn,format(result))
    end
    def format(result) do
        Enum.map(result,fn(x) -> %{"name" => x.name,"id" => x.id} end )
    end
end