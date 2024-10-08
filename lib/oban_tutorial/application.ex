defmodule ObanTutorial.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ObanTutorialWeb.Telemetry,
      # Start the Ecto repository
      ObanTutorial.Repo,
      {Oban, Application.fetch_env!(:oban_tutorial, Oban)},
      # Start the PubSub system
      {Phoenix.PubSub, name: ObanTutorial.PubSub},
      # Start Finch
      {Finch, name: ObanTutorial.Finch},
      # Start the Endpoint (http/https)
      ObanTutorialWeb.Endpoint
      # Start a worker by calling: ObanTutorial.Worker.start_link(arg)
      # {ObanTutorial.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ObanTutorial.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ObanTutorialWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
