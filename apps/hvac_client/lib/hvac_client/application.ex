defmodule HVACClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias HVACClient.Devices.Device

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: HVACClient.Worker.start_link(arg)
      # {HVACClient.Worker, arg}
      {Registry, keys: :unique, name: Registry.DeviceRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: HVACClient.DeviceSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HVACClient.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_phase(:start_devices, _, _) do
    Device.run(%{device_id: "us1", name: "device_us1"})
    Device.run(%{device_id: "us2", name: "device_us2"})
    Device.run(%{device_id: "us3", name: "device_us3"})
    Device.run(%{device_id: "us4", name: "device_us4"})
    Device.run(%{device_id: "us5", name: "device_us5"})
    :ok
  end
end
