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

  def accept_user(_conn, sourceUser, destinationUser) do
    from(p in Relation,
         where: p.sourceID == ^destinationUser
         and    p.destinationID == ^sourceUser)
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
end