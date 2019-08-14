defmodule ShowsStore.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ShowsStore.Repo
    ]

    opts = [strategy: :one_for_one, name: ShowsStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
