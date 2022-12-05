defmodule LawAdvisorRyanTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LawAdvisorRyanTestWeb.Telemetry,
      # Start the Ecto repository
      LawAdvisorRyanTest.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LawAdvisorRyanTest.PubSub},
      # Start Finch
      {Finch, name: LawAdvisorRyanTest.Finch},
      # Start the Endpoint (http/https)
      LawAdvisorRyanTestWeb.Endpoint
      # Start a worker by calling: LawAdvisorRyanTest.Worker.start_link(arg)
      # {LawAdvisorRyanTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LawAdvisorRyanTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LawAdvisorRyanTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
