defmodule RateLimiter do
  @moduledoc """
  Provides a rate limiter for jobs.

  ## Example

      {:ok, limiter} = RateLimiter.create(:my_limiter)
      1..5
      |> Enum.map(&RateLimiter.submit(limiter, fn -> RateLimiter.dummy_job(&1) end))
      |> Enum.map(&Task.await/1) # [1, 2, 3, 4, 5]
      RateLimiter.stop(limiter)

  """

  alias RateLimiter.Limiter

  @supervisor RateLimiter.LimitersSupervisor

  @spec create(atom, [{:max_demand, number} | {:interval, number}]) :: pid
  def create(name, scheduler_args \\ []) do
    DynamicSupervisor.start_child(
      @supervisor,
      {Limiter, {name, scheduler_args, []}}
    )
  end

  @spec submit(pid, (none -> any)) :: Task.t()
  def submit(limiter, job) do
    Task.async(fn ->
      if Process.alive?(limiter) do
        Limiter.submit(limiter, get_job(job, self()))

        receive do
          {:result, result} -> {:ok, result}
        end
      else
        {:error, :limiter_doesnt_exist}
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

  def stop(limiter) do
    DynamicSupervisor.terminate_child(@supervisor, limiter)
  end

  def dummy_job(i) do
    Process.sleep(2000)
    IO.inspect(i)
  end
end
