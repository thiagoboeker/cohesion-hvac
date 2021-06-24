defmodule HVACClient.Devices.Device do
  @moduledoc false

  use GenServer

  alias HVACDatabase.DeviceModel

  alias HVACDatabase.Pubsub.RabbitMQ

  def start_link(%{device_id: device_id} = data) do
    GenServer.start_link(__MODULE__, data,
      name: {:via, Registry, {Registry.DeviceRegistry, device_id}}
    )
  end

  def init(data) do
    case DeviceModel.get_or_create(data) do
      {:ok, device} ->

        schedule()

        {:ok, %{device: device}}
      _ ->
        {:error, "DATABASE FAIL"}
    end
  end

  def schedule(), do: Process.send_after(self(), :publish, 3_000)

  def handle_info(:publish, state) do
    data = generate(state)

    RabbitMQ.publish(data)

    schedule()

    {:noreply, state}
  end

  def generate(state) do
    Jason.encode!(
      %{
        "dev_id" => state.device.id,
        "device_id" => state.device.device_id,
        "current_value" => :rand.uniform(50_000),
        "unit" => "cm",
        "version" => 1.2,
        "timestamp" => DateTime.utc_now()
      }
    )
  end

  def run(data) do
    DynamicSupervisor.start_child(HVACClient.DeviceSupervisor, {__MODULE__, data})
  end
end
