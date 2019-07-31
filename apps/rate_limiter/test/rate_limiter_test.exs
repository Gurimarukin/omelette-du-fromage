defmodule RateLimiterTest do
  use ExUnit.Case
  doctest RateLimiter

  test "greets the world" do
    assert RateLimiter.hello() == :world
  end
end
