defmodule GgenkiWeb.PageController do
  use GgenkiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
