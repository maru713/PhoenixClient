defmodule PhoenixclientWeb.RelationController do
  use PhoenixclientWeb, :controller

  alias Phoenixclient.Relations
  alias Phoenixclient.Relations.Relation
  alias Phoenixclient.Accounts

  def index(conn, _params) do
    relation = Relations.list_relation()
    render(conn, "index.json", relation: relation)
  end

  def new(conn, _params) do
    changeset = Relations.change_relation(%Relation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"relation" => relation_params}) do
    case Relations.create_relation(relation_params) do
      {:ok, relation} ->
        conn
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

  def add(conn,_) do
    relation = %{sourceID: conn.params["id"],destinationID: conn.params["destinationID"],status: false}
    case Relations.check_rel(relation) do
      true -> rel_success(conn,relation)
      false ->  json(conn, %{message: "Oops,your friend request have been already submited or accepted!"})
    end
  end

  defp rel_success(conn,relation) do
    message =
      Relations.check_duplicate(relation)
    json(conn, %{message: message})
  end

  def incoming(conn, _) do
    inc =
      conn.params["id"]
      |>Relations.get_incoming_users()
    render(conn, "index.json", relation: inc)
  end

  def accept(conn, _) do
    Relations.accept_user(conn.params["id"], conn.params["destinationID"])
    json(conn, %{message: "Success!"})
  end
end
