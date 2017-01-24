defmodule Callforpapers.PageControllerTest do
  use Callforpapers.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Call-for-Papers"
  end
end
