defmodule PanWeb.HelloController do
  use PanWeb, :controller

  def world(conn, %{"name" => name}) do
    render(conn, "world.html", name: name)
  end

  def world(conn, _params) do
    render(conn, "world.html", name: "world")
  end
end
