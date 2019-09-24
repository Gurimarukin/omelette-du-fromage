defmodule PanWeb.LayoutView do
  use PanWeb, :view

  def cat_link(conn, label, to: to) do
    class =
      if Phoenix.Controller.current_path(conn, %{}) === to do
        "root__link_current"
      else
        "root__link"
      end

    link(label, to: to, class: class)
  end
end
