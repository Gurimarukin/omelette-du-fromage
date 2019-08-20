defmodule RateLimiterTest do
  use ExUnit.Case
  doctest RateLimiter

  test "creates limiters" do
    assert RateLimiter.whereis(:limiter1) == nil
    assert RateLimiter.whereis(:limiter2) == nil

    res = RateLimiter.with_limit(:limiter1, fn -> :toto end) |> Task.await()
    assert res == :toto

    assert RateLimiter.whereis(:limiter1) != nil
    assert RateLimiter.whereis(:limiter2) == nil

    res = RateLimiter.with_limit(:limiter2, fn -> :toto end) |> Task.await()
    assert res == :toto

    assert RateLimiter.whereis(:limiter1) != nil
    assert RateLimiter.whereis(:limiter2) != nil

    assert RateLimiter.stop(:limiter1) == :ok

    assert RateLimiter.whereis(:limiter1) == nil
    assert RateLimiter.whereis(:limiter2) != nil

    assert RateLimiter.stop(:limiter2) == :ok

    assert RateLimiter.whereis(:limiter1) == nil
    assert RateLimiter.whereis(:limiter2) == nil

    assert RateLimiter.stop(:limiter2) == {:ok, :already_stopped}

    before = Time.utc_now()

    res =
      1..6
      |> Enum.map(
        &RateLimiter.with_limit(:limiter, fn -> &1 end,
          max_demand: 3,
          interval: 500
        )
      )
      |> Enum.map(&Task.await/1)

    diff = Time.diff(Time.utc_now(), before, :millisecond)

    assert res == [1, 2, 3, 4, 5, 6]
    assert diff >= 1000
    assert diff < 1500
  end
end
