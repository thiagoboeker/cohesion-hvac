defmodule HVACDatabase.DeviceModel do
  @moduledoc false
  
  alias HVACDatabase.DeviceSchema
  alias HVACDatabase.Repo

  def schema(), do: HVACDatabase.DeviceSchema

  def get_or_create(data) do
    %DeviceSchema{}
    |> DeviceSchema.changeset(data)
    |> Repo.insert(
      on_conflict: :replace_all,
      conflict_target: :device_id
    )
  end
end
