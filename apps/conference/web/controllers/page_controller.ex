defmodule Conference.PageController do
  use Conference.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
