defmodule HVACServer.Support.Generator do

  def reads_payload() do
    [
      %{
        "device_id" => "123-789",
        "current_value" => 100.0,
        "unit" => "meter",
        "timestamp" => "2021-06-22 12:00:10",
        "version" => 1.2
      },
      %{
        "device_id" => "123-789",
        "current_value" => 50.0,
        "unit" => "meter",
        "timestamp" => "2021-06-22 12:00:13",
        "version" => 1.2
      },
      %{
        "device_id" => "123-789",
        "current_value" => 50.0,
        "unit" => "meter",
        "timestamp" => "2021-06-22 12:01:13",
        "version" => 1.2
      },
      %{
        "device_id" => "123-560",
        "current_value" => 100.0,
        "unit" => "meter",
        "timestamp" => "2021-06-22 12:00:16",
        "version" => 1.2
      }
    ]
  end
end
