defmodule PhoenixclientWeb.LoginView do
  use PhoenixclientWeb, :view
  alias PhoenixclientWeb.LoginView

  def render("index.json", %{changesets: changesets}) do
    %{data: render_many(changesets, LoginView, "login.json")}
  end

  def render("show.json", %{changeset: changeset}) do
    %{data: render_one(changeset, LoginView, "login.json")}
  end

  def render("login.json", %{response: response}) do
    %{data: response}
  end

  def render("login-error.json", %{response: response}) do
    %{data: %{
      error: "Invalid request",
      error_description: "Incorrect email or password."
      }
    }
  end

  def render("logout.json", %{response: _}) do
    %{data: %{
      success: "Request success",
      success_description: "Logout."
      }
    }
  end

  def render("logout-error.json", %{response: _}) do
    %{data: %{
      error: "Invalid request",
      error_description: "Cannot logout."
      }
    }
  end

  def render("expired.json", _) do
    %{data: %{
      error: "Invalid request",
      error_description: "Access token expired."
      }
    }
  end

end