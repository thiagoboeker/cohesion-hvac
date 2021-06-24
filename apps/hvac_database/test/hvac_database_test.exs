defmodule HVACDatabaseTest do
  use ExUnit.Case
  doctest HVACDatabase

  alias HVACDatabase.DeviceModel
  alias HVACDatabase.ReadingModel


  setup do
    device = %{
      device_id: Ecto.UUID.autogenerate(),
      name: "device_101"
    }

    {:ok, %{device: device}}
  end

  test "CREATE Devices", %{device: device} do
    {:ok, _device} = DeviceModel.get_or_create(device)
  end

  test "CREATE Readings", %{device: device} do
    {:ok, device} = DeviceModel.get_or_create(device)

    reading = %{
      version: 2.1,
      timestamp: "2021-06-20 12:00:00",
      device_id: device.id,
      device_uid: device.device_id,
      current_value: 1.2,
      unit: "unit1"
    }

    {:ok, _reading} = ReadingModel.get_or_create(reading)
  end
end
