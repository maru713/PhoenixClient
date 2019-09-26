defmodule Phoenixclient.Relations do
  @moduledoc """
  The Relations context.
  """

  import Ecto.Query, warn: false
  alias Phoenixclient.Repo
  alias Phoenixclient.Accounts.User

  alias Phoenixclient.Relations.Relation

  @doc """
  Returns the list of relation.

  ## Examples

      iex> list_relation()
      [%Relation{}, ...]

  """
  def list_relation do
    Repo.all(Relation)
  end

  def get_incoming_users(userid) do
    inc = Relation
          |>where([u], u.destinationID == ^userid)
          |>where([u], not u.status)
          |>Repo.all

    Enum.map(inc, fn r ->
              User
              |> where([u], u.id == ^r.sourceID)
              |> Repo.one()
            end)
  end

  @doc """
  Gets a single relation.

  Raises `Ecto.NoResultsError` if the Relation does not exist.

  ## Examples

      iex> get_relation!(123)
      %Relation{}

      iex> get_relation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_relation!(id), do: Repo.get!(Relation, id)

  @doc """
  Creates a relation.

  ## Examples

      iex> create_relation(%{field: value})
      {:ok, %Relation{}}

      iex> create_relation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_relation(attrs \\ %{}) do
    val = Map.put(attrs, :status, false)
    %Relation{}
    |> Relation.changeset(val)
    |> Repo.insert()
    |>IO.inspect
    "Sent the friend request!"
  end

  @doc """
  Updates a relation.

  ## Examples

      iex> update_relation(relation, %{field: new_value})
      {:ok, %Relation{}}

      iex> update_relation(relation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_relation(%Relation{} = relation, attrs) do
    relation
    |> Relation.changeset(attrs)
    |> Repo.update()
  end

  def accept_user(id, destinationUser) do
    from(p in Relation,
        where: p.sourceID == ^destinationUser
        and    p.destinationID == ^id)
    |> Repo.update_all(set: [status: true])
  end
  @doc """
  Deletes a Relation.

  ## Examples

      iex> delete_relation(relation)
      {:ok, %Relation{}}

      iex> delete_relation(relation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_relation(%Relation{} = relation) do
    Repo.delete(relation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking relation changes.

  ## Examples

      iex> change_relation(relation)
      %Ecto.Changeset{source: %Relation{}}

  """
  def change_relation(%Relation{} = relation) do
    Relation.changeset(relation, %{})
  end

  def check_rel(rel) do
    query = 
      from u in Relation,
      where: (u.sourceID == ^rel.sourceID and u.destinationID == ^rel.destinationID)
      or (u.sourceID == ^rel.destinationID and u.destinationID == ^rel.sourceID and u.status == true)
    Repo.one(query)
    |>is_nil   
  end

  def searchfriend(id) do
    sourceside =
      Relation
      |>where([u],u.sourceID == ^id)
      |>where([u], u.status ==true)
      |>Repo.all()
      |>Enum.map(fn(x) -> x.destinationID end)

    destinationside =
      Relation
      |>where([u],u.destinationID == ^id)
      |>where([u], u.status == true)
      |>Repo.all()
      |>Enum.map(fn(x) -> x.sourceID end)
    destinationside ++ sourceside
  end

  def check_duplicate(relation) do
    query =
      from u in Relation,
      where:
        ^relation.sourceID == u.destinationID
        and ^relation.destinationID  == u.sourceID

      rel = Repo.one(query)
    case is_nil(rel) do
      true -> create_relation(relation)
      false -> adjust_duplicate(rel)
    end
  end

  defp adjust_duplicate(relation) do
    accept_user(relation.destinationID,relation.sourceID)
    "Became friend!"
  end
end
