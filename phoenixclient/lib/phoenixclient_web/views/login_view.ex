defmodule PhoenixclientWeb.LoginView do
  use PhoenixclientWeb, :view
  alias PhoenixclientWeb.LoginView
  def render("index.json", %{changesets: changesets}) do
    %{data: render_many(changesets, LoginView, "login.json")}
  end

  def render("show.json", %{changeset: changeset}) do
    %{data: render_one(changeset, LoginView, "login.json")}
  end

end