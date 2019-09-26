defmodule PhoenixclientWeb.UserController do
  use PhoenixclientWeb, :controller

  alias Phoenixclient.Accounts
  alias Phoenixclient.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn,_user) do
    IO.inspect("params=")
    IO.inspect(conn)
    user_params = 
      %{"name" => conn.params["name"],"email" => conn.params["email"],"password" => conn.params["password"]}
      |>IO.inspect
    case Accounts.create_user(user_params) do
      {:ok, user} -> 
        redirect(conn,to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        send_resp(conn, 502, "Oops, something went wrong!")
    end
  end

  def show(conn, _) do
    user = Accounts.get_user!(conn.params["id"])
    render(conn, "show.json", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def get_user(conn, _) do
    user = Accounts.get_user_from_id(conn.params["id"])
    render(conn, "user.json", user: user)
  end
end
