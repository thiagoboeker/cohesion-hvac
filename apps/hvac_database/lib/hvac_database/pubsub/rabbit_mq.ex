defmodule HVACDatabase.Pubsub.RabbitMQ do
  @moduledoc
  """
    RabbitMQ wrapper for the reading queue.
  """

  @behaviour GenRMQ.Publisher

  require Logger

  defp aqmp_url(), do: Application.fetch_env!(:hvac_database, :amqp_url)

  @doc false
  def start_link do
    GenRMQ.Publisher.start_link(__MODULE__, name: __MODULE__)
  end

  @doc false
  def init() do
    setup_queue()

    [
      exchange: "devices",
      connection: aqmp_url(),
      queue: "readings",
      prefetch_count: "10",
      concurrency: true,
      reconect: true,
      queue_options: [durable: true]
    ]
  end

  defp setup_queue do
    # Setup RabbitMQ connection

    {:ok, connection} = AMQP.Connection.open(aqmp_url())
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Exchange.declare(channel, "devices", :topic, durable: true)

    # Create queue
    AMQP.Queue.declare(channel, "readings", durable: true)

    AMQP.Queue.bind(channel, "readings", "devices")

    AMQP.Channel.close(channel)
  end

  @doc
  """
    Publish data in the queue.

    Data must be in json encoded format.
  """
  def publish(data) do
    GenRMQ.Publisher.publish(__MODULE__, data)
  end


end
