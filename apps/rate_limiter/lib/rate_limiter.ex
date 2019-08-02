defmodule RateLimiter do
  alias RateLimiter.Limiter

  @supervisor RateLimiter.LimitersSupervisor

  @spec create([{:max_demand, number} | {:interval, number}]) :: pid
  def create(args \\ []) do
    {:ok, limiter} =
      DynamicSupervisor.start_child(
        @supervisor,
        {Limiter, [args]}
      )

    limiter
  end

  @spec submit(pid, (none -> any)) :: Task.t()
  def submit(limiter, job) do
    Task.async(fn ->
      Limiter.submit(limiter, get_job(job, self()))

      receive do
        {:result, result} -> result
      end
    end)
  end

  defp get_job(job, parent) do
    fn ->
      Task.start_link(fn ->
        result = job.()
        send(parent, {:result, result})
      end)
    end
  end

  # 1..100 |> Enum.map(& RateLimiter.submit(limiter, fn -> RateLimiter.dummy_job(&1) end)) |> Enum.map(&Task.await/1)

  def dummy_job(i) do
    Process.sleep(2000)
    i
  end

  def stop(limiter) do
    DynamicSupervisor.terminate_child(@supervisor, limiter)
  end
end
