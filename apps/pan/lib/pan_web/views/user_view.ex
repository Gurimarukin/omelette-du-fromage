defmodule PanWeb.UserView do
  use PanWeb, :view

  alias Pan.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
