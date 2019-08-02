defmodule RateLimiter.Limiter do
  use GenServer

  alias RateLimiter.{Scheduler, Queue}

  @doc """

  `args`: arguments for Scheduler.init/1

    * `max_demand`: integer, default: `5`

    * `interval`: integer, interval in ms, default: `1000`

  """
  @spec start_link([{:max_demand, number} | {:interval, number}], any) :: any
  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @impl true
  def init(args) do
    {:ok, queue} = Queue.start_link()
    {:ok, scheduler} = Scheduler.start_link(args)

    GenStage.sync_subscribe(scheduler, to: queue)

    {:ok, queue}
  end

  def submit(limiter, job) do
    GenServer.call(limiter, {:submit, job})
  end

  @impl true
  def handle_call({:submit, job}, _from, queue) do
    Queue.in(queue, job)
    {:reply, :ok, queue}
  end
end
