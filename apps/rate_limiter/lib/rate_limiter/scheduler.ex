defmodule RateLimiter.Scheduler do
  use GenStage

  def start_link(args \\ [], opts \\ []) do
    GenStage.start_link(__MODULE__, args, opts)
  end

  @impl true
  def init(args) do
    args = %{
      max_demand: args[:max_demand] || 5,
      interval: args[:interval] || 1000
    }

    {:consumer, {args, %{}}}
  end

  @impl true
  def handle_subscribe(:producer, _opts, from, {args, _}) do
    producer = %{
      producer: from,
      pending: args.max_demand
    }

    {:manual, ask_and_schedule({args, producer})}
  end

  @impl true
  def handle_cancel(_, _from, {args, _}) do
    {:noreply, [], {args, nil}}
  end

  @impl true
  def handle_events(events, _from, {args, producer}) do
    producer = Map.update!(producer, :pending, &(&1 - length(events)))

    events
    |> Enum.map(& &1.())

    {:noreply, [], {args, producer}}
  end

  @impl true
  def handle_info(:ask, {args, producer}) do
    state = {args, Map.update!(producer, :pending, fn _ -> args.max_demand end)}
    {:noreply, [], ask_and_schedule(state)}
  end

  defp ask_and_schedule({args, producer}) do
    GenStage.ask(producer.producer, producer.pending)
    Process.send_after(self(), :ask, args.interval)
    {args, producer}
  end
end
