defmodule Phoenixclient.RelationsTest do
  use Phoenixclient.DataCase

  alias Phoenixclient.Relations

  describe "relation" do
    alias Phoenixclient.Relations.Relation

    @valid_attrs %{destinationID: 42, sourceID: 42, status: true}
    @update_attrs %{destinationID: 43, sourceID: 43, status: false}
    @invalid_attrs %{destinationID: nil, sourceID: nil, status: nil}

    def relation_fixture(attrs \\ %{}) do
      {:ok, relation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Relations.create_relation()

      relation
    end

    test "list_relation/0 returns all relation" do
      relation = relation_fixture()
      assert Relations.list_relation() == [relation]
    end

    test "get_relation!/1 returns the relation with given id" do
      relation = relation_fixture()
      assert Relations.get_relation!(relation.id) == relation
    end

    test "create_relation/1 with valid data creates a relation" do
      assert {:ok, %Relation{} = relation} = Relations.create_relation(@valid_attrs)
      assert relation.destinationID == 42
      assert relation.sourceID == 42
      assert relation.status == true
    end

    test "create_relation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Relations.create_relation(@invalid_attrs)
    end

    test "update_relation/2 with valid data updates the relation" do
      relation = relation_fixture()
      assert {:ok, %Relation{} = relation} = Relations.update_relation(relation, @update_attrs)
      assert relation.destinationID == 43
      assert relation.sourceID == 43
      assert relation.status == false
    end

    test "update_relation/2 with invalid data returns error changeset" do
      relation = relation_fixture()
      assert {:error, %Ecto.Changeset{}} = Relations.update_relation(relation, @invalid_attrs)
      assert relation == Relations.get_relation!(relation.id)
    end

    test "delete_relation/1 deletes the relation" do
      relation = relation_fixture()
      assert {:ok, %Relation{}} = Relations.delete_relation(relation)
      assert_raise Ecto.NoResultsError, fn -> Relations.get_relation!(relation.id) end
    end

    test "change_relation/1 returns a relation changeset" do
      relation = relation_fixture()
      assert %Ecto.Changeset{} = Relations.change_relation(relation)
    end
  end
end
