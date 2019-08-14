defmodule RateLimiterTest do
  use ExUnit.Case
  doctest RateLimiter

  test "creates a limiter" do
    {:ok, limiter} = RateLimiter.create(:my_limiter)

    res = RateLimiter.submit(limiter, fn -> :toto end) |> Task.await()
    assert res == {:ok, :toto}

    {:error,
     {:shutdown,
      {:failed_to_start_child, {RateLimiter.Queue, :my_limiter}, {:already_started, queue}}}} =
      RateLimiter.create(:my_limiter)

    assert queue != limiter
  end

  test "stops a limiter" do
    {:ok, limiter} = RateLimiter.create(:other_limiter)

    assert RateLimiter.stop(limiter) == :ok

    res = RateLimiter.submit(limiter, fn -> :toto end) |> Task.await()

    assert res == {:error, :limiter_doesnt_exist}

    assert RateLimiter.stop(limiter) == {:error, :not_found}
  end

  test "respects rate" do
    {:ok, limiter} = RateLimiter.create(:a_limiter, max_demand: 3, interval: 2000)

    before = Time.utc_now()

    res =
      1..6
      |> Enum.map(&RateLimiter.submit(limiter, fn -> &1 end))
      |> Enum.map(&Task.await/1)

    diff = Time.diff(Time.utc_now(), before, :millisecond)

    assert res == [{:ok, 1}, {:ok, 2}, {:ok, 3}, {:ok, 4}, {:ok, 5}, {:ok, 6}]
    assert diff >= 4000
    assert diff < 5000
  end
end
