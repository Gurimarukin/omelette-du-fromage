defmodule RateLimiter.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: RateLimiter.LimitersSupervisor, strategy: :one_for_one}
    ]

    opts = [strategy: :one_for_one, name: RateLimiter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
