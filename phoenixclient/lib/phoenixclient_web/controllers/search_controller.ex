defmodule PhoenixclientWeb.SearchController do
    use PhoenixclientWeb, :controller

    action_fallback PhoenixclientWeb.FallbackController
    alias Phoenixclient.Accounts
    alias Phoenixclient.Locations
    alias PhoenixclientWeb.ResultView

    def search(conn,_) do
        result = 
            conn.params["searchtmp"]
            |>Accounts.searchName()
        json(conn,formatuser(result))
    end
    defp formatuser(result) do
        Enum.map(result,fn(x) -> %{"name" => x.name,"id" => x.id} end )
    end


    def locsearch(conn,_) do
        word = conn.params["word"]#検索文字
        userid = conn.params["id"]#検索者のid
        result = Locations.search(word,userid)
        json(conn,formatloc(result))
    end
    defp formatloc(result) do
        Enum.map(result,fn(x) -> %{"place" => x.place,"latitude" => x.latitude,"longitude" => x.longitude} end)
    end
end