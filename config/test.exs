
import Config

config :hvac_database, HVACDatabase.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "hvac_database_test",
  hostname: "localhost",
  port: 15432,
  pool: Ecto.Adapters.SQL.Sandbox


config :hvac_database, :amqp_host, "amqp://test-user:147248@localhost:5672"
config :hvac_database, :amqp_user, "test-user"
config :hvac_database, :amqp_pass, "147248"
