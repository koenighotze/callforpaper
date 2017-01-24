defmodule Callforpapers.PageController do
  use Callforpapers.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
