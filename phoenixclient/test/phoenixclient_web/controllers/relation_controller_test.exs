defmodule PhoenixclientWeb.RelationControllerTest do
  use PhoenixclientWeb.ConnCase

  alias Phoenixclient.Relations

  @create_attrs %{destinationID: 42, sourceID: 42, status: true}
  @update_attrs %{destinationID: 43, sourceID: 43, status: false}
  @invalid_attrs %{destinationID: nil, sourceID: nil, status: nil}

  def fixture(:relation) do
    {:ok, relation} = Relations.create_relation(@create_attrs)
    relation
  end

  describe "index" do
    test "lists all relation", %{conn: conn} do
      conn = get(conn, Routes.relation_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Relation"
    end
  end

  describe "new relation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.relation_path(conn, :new))
      assert html_response(conn, 200) =~ "New Relation"
    end
  end

  describe "create relation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.relation_path(conn, :create), relation: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.relation_path(conn, :show, id)

      conn = get(conn, Routes.relation_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Relation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.relation_path(conn, :create), relation: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Relation"
    end
  end

  describe "edit relation" do
    setup [:create_relation]

    test "renders form for editing chosen relation", %{conn: conn, relation: relation} do
      conn = get(conn, Routes.relation_path(conn, :edit, relation))
      assert html_response(conn, 200) =~ "Edit Relation"
    end
  end

  describe "update relation" do
    setup [:create_relation]

    test "redirects when data is valid", %{conn: conn, relation: relation} do
      conn = put(conn, Routes.relation_path(conn, :update, relation), relation: @update_attrs)
      assert redirected_to(conn) == Routes.relation_path(conn, :show, relation)

      conn = get(conn, Routes.relation_path(conn, :show, relation))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, relation: relation} do
      conn = put(conn, Routes.relation_path(conn, :update, relation), relation: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Relation"
    end
  end

  describe "delete relation" do
    setup [:create_relation]

    test "deletes chosen relation", %{conn: conn, relation: relation} do
      conn = delete(conn, Routes.relation_path(conn, :delete, relation))
      assert redirected_to(conn) == Routes.relation_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.relation_path(conn, :show, relation))
      end
    end
  end

  defp create_relation(_) do
    relation = fixture(:relation)
    {:ok, relation: relation}
  end
end
