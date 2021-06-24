defmodule HVACDatabase.ReadingModel do
  @moduledoc false

  alias HVACDatabase.ReadingSchema
  alias HVACDatabase.Repo
  import Ecto.Changeset

  alias Ecto.Multi

  require Logger

  def get_or_create(data) do
    %ReadingSchema{}
    |> ReadingSchema.changeset(data)
    |> Repo.insert()
  end

  # Used for cast raw data in a fully schema
  def transform(params) do
    %ReadingSchema{}
    |> ReadingSchema.changeset(params)
    |> apply_changes()
  end

  def insert_all(data, batch_id) do
    # Honestly, the decision for Multi here doesnt have anything to do with consistency
    # I used just for simplicity
    
    result =
      data
      |> Enum.reduce(Multi.new(), fn read, multi -> Multi.insert(multi, Ecto.UUID.autogenerate(), ReadingSchema.changeset(read, %{batch_id: batch_id})) end)
      |> Repo.transaction()

    case result do
      {:ok, _} ->
        Logger.info("Data from batch: #{batch_id} inserted sucessfully.")
      _ ->
        Logger.info("Data from batch: #{batch_id} insert failed.")
    end

    result
  end
end
