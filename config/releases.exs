import Config

config :hvac_database, HVACDatabase.Repo,
  adapter: Ecto.Adapters.Postgres,
  url:  System.fetch_env!("DATABASE_URL")

config :hvac_database, :amqp_host, System.fetch_env!("AMQP_HOST")
config :hvac_database, :database_url, System.fetch_env!("DATABASE_URL")
config :hvac_database, :amqp_url,  System.fetch_env!("AMQP_URL")
config :hvac_database, :amqp_user, System.fetch_env!("AMQP_USER")
config :hvac_database, :amqp_pass, System.fetch_env!("AMQP_PASS")
