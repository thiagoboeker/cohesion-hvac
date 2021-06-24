defmodule HVACServer.ReadingsAggregator do
  @moduledoc false

  use GenServer

  alias HVACDatabase.ReadingSchema

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end
  
  defp empty_device() do
    %{
      last_read: %ReadingSchema{},
      average: 0,
      acc: []
    }
  end

  defp average(device) do

    first_read = Enum.at(device.acc, 0) || device.last_read # just to make the comparison safe

    last_read = device.last_read

    case DateTime.diff(last_read.timestamp, first_read.timestamp, :millisecond) do

      # The aggregator doesnt have any trigger, so we use the leap between the
      # reads to calculate.
      # Not optimal but, it is the simplest solution for now.
      interval when interval >= 60_000 ->

        avg = Enum.reduce(device.acc, 0, fn read, acc ->
          acc + (read.current_value / length(device.acc))
        end)

        Logger.info("Device #{device.last_read.device_id} Last minute average: #{avg}")

        device
        |> Map.put(:average, avg)
        |> Map.put(:acc, [last_read])

      _ ->
         Map.put(device, :acc, device.acc ++ [last_read])
    end
  end

  defp add_device(device, device_id, state), do: Map.put(state, device_id, device)

  def handle_cast({:read, read}, state) do
    device = Map.get(state, read.device_id, empty_device())
    {:noreply,
      device
      |> Map.put(:last_read, read)
      |> average()
      |> add_device(read.device_id, state)}
  end

  def add(read) do
    GenServer.cast(__MODULE__, {:read, read})
  end
end
