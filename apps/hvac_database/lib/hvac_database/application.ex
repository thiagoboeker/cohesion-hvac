defmodule HVACDatabase.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: HVACDatabase.Worker.start_link(arg)
      # {HVACDatabase.Worker, arg}
      HVACDatabase.Repo,
      %{
        id: HVACDatabase.Pubsub.RabbitMQ,
        start: {HVACDatabase.Pubsub.RabbitMQ, :start_link, []}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HVACDatabase.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
