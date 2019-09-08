defmodule PhoenixclientWeb.RelationController do
  use PhoenixclientWeb, :controller

  alias Phoenixclient.Relations
  alias Phoenixclient.Relations.Relation
  alias Phoenixclient.Accounts

  def index(conn, _params) do
    relation = Relations.list_relation()
    render(conn, "index.html", relation: relation)
  end

  def new(conn, _params) do
    changeset = Relations.change_relation(%Relation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"relation" => relation_params}) do
    case Relations.create_relation(relation_params) do
      {:ok, relation} ->
        conn
        |> put_flash(:info, "Relation created successfully.")
        |> redirect(to: Routes.relation_path(conn, :show, relation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    relation = Relations.get_relation!(id)
    render(conn, "show.html", relation: relation)
  end

  def edit(conn, %{"id" => id}) do
    relation = Relations.get_relation!(id)
    changeset = Relations.change_relation(relation)
    render(conn, "edit.html", relation: relation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "relation" => relation_params}) do
    relation = Relations.get_relation!(id)

    case Relations.update_relation(relation, relation_params) do
      {:ok, relation} ->
        conn
        |> put_flash(:info, "Relation updated successfully.")
        |> redirect(to: Routes.relation_path(conn, :show, relation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", relation: relation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    relation = Relations.get_relation!(id)
    {:ok, _relation} = Relations.delete_relation(relation)

    conn
    |> put_flash(:info, "Relation deleted successfully.")
    |> redirect(to: Routes.relation_path(conn, :index))
  end
  def add(conn, %{"destinationID" => destinationID}) do
    current_user = Accounts.current_user(conn)
    relation = %{sourceID: current_user.id,destinationID: destinationID,status: false}
    Relations.create_relation(relation)
    redirect(conn, to: "/users")
  end

  def incoming(conn, _) do
    current_userID = Accounts.current_user(conn).id
    
    inc = Relations.get_incoming_users(current_userID)

    render(conn, "incoming.html", users: inc)
  end
  def accept(conn, %{"destinationID" => destinationID}) do
    current_user = Accounts.current_user(conn)
    Relations.accept_user(conn, current_user.id, destinationID)
    redirect(conn, to: "/incoming")
  end
end
