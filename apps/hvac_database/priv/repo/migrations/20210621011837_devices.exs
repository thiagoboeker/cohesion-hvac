defmodule HVACDatabase.Repo.Migrations.Devices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :device_id, :string
      add :name, :string
      timestamps(type: :utc_datetime)
    end

    create unique_index(:devices, :device_id)
  end
end
