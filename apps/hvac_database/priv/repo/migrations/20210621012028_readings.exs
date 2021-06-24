defmodule HVACDatabase.Repo.Migrations.Readings do
  use Ecto.Migration

  def change do
    create table(:readings) do
      add :device_id, :string
      add :current_value, :float
      add :unit, :string
      add :timestamp, :utc_datetime
      add :version, :float
      add :batch_id, :string
      add :dev_id, references(:devices)
    end
  end
end
