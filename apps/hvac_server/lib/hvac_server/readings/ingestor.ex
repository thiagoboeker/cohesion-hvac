defmodule HVACServer.ReadingsIngestor do
  @moduledoc false

  use Broadway

  alias Broadway.Message

  alias  HVACServer.ReadingsAggregator

  alias HVACDatabase.ReadingModel

  defp amqp_user(), do: Application.fetch_env!(:hvac_database, :amqp_user)
  defp amqp_pass(), do: Application.fetch_env!(:hvac_database, :amqp_pass)
  defp amqp_host(), do: Application.fetch_env!(:hvac_database, :amqp_host)

  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: HVACServer.ReadingsIngestor,
      producer: [
        module: {BroadwayRabbitMQ.Producer,
          queue: "readings",
          qos: [
            prefetch_count: 50,
          ],
          connection: [
            host: amqp_host(),
            username: amqp_user(),
            password: amqp_pass(),
          ],
          on_failure: :reject_and_requeue_once
        },
        concurrency: 50,
      ],
      processors: [
        default: [
          concurrency: 50
        ]
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 4_000,
          concurrency: 20
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do

    # The data in the message should be a schema.
    # With this pattern we can leverage Ecto to help process
    # and validate the data if necessary.
    message = Message.update_data(message, fn d -> ReadingModel.transform(Jason.decode!(d)) end)

    ReadingsAggregator.add(message.data)


    # Basic batching just to reduce IO, nothing more
    Message.put_batcher(message, :default)
  end

  @impl true
  def handle_batch(_, batch, _, _) do
    batch_id = Ecto.UUID.autogenerate()

    batch
    |> Enum.map(fn message -> message.data end)
    |> ReadingModel.insert_all(batch_id)

    batch
  end
end
