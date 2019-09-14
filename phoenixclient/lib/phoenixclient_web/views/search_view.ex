defmodule PhoenixclientWeb.ResultView do
  use PhoenixclientWeb, :view
  alias PhoenixclientWeb.ResultView
  
  def render("result.json", %{result: result}) do
    %{data: render_many(result, ResultView, "search.json")}
  end
end