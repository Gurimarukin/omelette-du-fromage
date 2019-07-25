defmodule ShowsStoreTest do
  use ExUnit.Case
  doctest ShowsStore

  test "greets the world" do
    assert ShowsStore.hello() == :world
  end
end
