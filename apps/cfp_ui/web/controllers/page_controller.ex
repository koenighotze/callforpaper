defmodule CfpUi.PageController do
  use CfpUi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
