defmodule HVACDatabase.Release do

  def migrate do
    Application.load(:hvac_database)

    repos = Application.fetch_env!(:hvac_database, :ecto_repos)

    for repo <- repos do
      {:ok, _, _} =  Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end
end
