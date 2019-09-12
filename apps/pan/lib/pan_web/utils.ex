defmodule PanWeb.Utils do
  def format_date_fr(date) do
    Timex.format!(date, "{0D}/{0M}/{YYYY}")
  end

  def format_time_fr(date) do
    Timex.format!(date, "{h24}h{m}")
  end

  def format_date_time_fr(date_time) do
    format_date_fr(date_time) <> ", " <> format_time_fr(date_time)
  end
end
