defmodule ScrapersTest do
  use ExUnit.Case

  test "gets" do
    assert Scrapers.get_bodys(["toto", "titi"], :name) == [
             {:ok, :toto},
             {:error, :not_found}
           ]
  end
end
