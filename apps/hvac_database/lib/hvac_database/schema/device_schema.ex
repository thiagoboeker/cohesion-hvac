defmodule HVACDatabase.DeviceSchema do
  use Ecto.Schema

  import Ecto.Changeset

  schema "devices" do
    field :device_id, :string
    field :name, :string
    timestamps(type: :utc_datetime)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:device_id, :name])
    |> validate_required([:device_id, :name])
    |> unique_constraint(:device_id)
  end
end
