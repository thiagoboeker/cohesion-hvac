defmodule HVACServerTest do
  use ExUnit.Case
  doctest HVACServer

  alias HVACServer.Support.Generator

  alias HVACServer.ReadingsAggregator

  alias HVACDatabase.ReadingModel

  alias HVACServer.ReadingsIngestor

  alias Broadway.Message

  alias HVACDatabase.ReadingSchema

  alias HVACDatabase.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(HVACDatabase.Repo)
  end

  test "READING AGGREGATOR handle_cast/read" do
    payload =
      Generator.reads_payload() # 3 reads
      |> Enum.map(&ReadingModel.transform/1)

    # IMPORTANT: Devices IDs -> 123-789 and 123-560

    {:noreply, state} = ReadingsAggregator.handle_cast({:read, Enum.at(payload, 0)}, %{})
    {:noreply, state} = ReadingsAggregator.handle_cast({:read, Enum.at(payload, 1)}, state)
    {:noreply, state} = ReadingsAggregator.handle_cast({:read, Enum.at(payload, 2)}, state)

    assert state["123-789"].average == 75.0 # 100.0 + 50.0 from the readings of the generator

    messages = Enum.map(state["123-789"].acc, fn message -> %Message{data: message, acknowledger: {DummyAcknowledger, :default, message}} end)

    batch = ReadingsIngestor.handle_batch(:default, messages, %Broadway.BatchInfo{}, %{})

    assert length(Repo.all(ReadingSchema)) == length(batch)
  end
end
