defmodule HVACDatabase.ReadingSchema do
  use Ecto.Schema

  import Ecto.Changeset

  schema "readings" do
    field :device_id, :string
    field :current_value, :float
    field :unit, :string
    field :timestamp, :utc_datetime
    field :version, :float
    field :batch_id, :string
    belongs_to :dev, HVACDatabase.DeviceSchema
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:current_value, :batch_id, :unit, :timestamp, :version, :device_id, :dev_id])
  end
end
