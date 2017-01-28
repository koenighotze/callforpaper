defmodule Callforpapers.LayoutViewTest do
  use Callforpapers.ConnCase, async: true
  import Phoenix.View

  @tag :skip
  # how to cope with  key :phoenix_endpoint not found in: %{phoenix_recycled: true, plug_skip_csrf_protection: true}
  test "menu items for unregistered user", %{conn: conn} do
    content = render_to_string(Callforpapers.LayoutView, "app.html", conn: conn, current_user: nil)

    assert String.contains?(content, "Register")
    assert String.contains?(content, "Login")
  end

end
