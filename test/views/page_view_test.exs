defmodule Callforpapers.PageViewTest do
  use Callforpapers.ConnCase, async: true
  import Phoenix.View

  alias Callforpapers.User

  test "entry for unregistered user", %{conn: conn} do
    content = render_to_string(Callforpapers.PageView, "index.html", conn: conn, current_user: nil)

    assert String.contains?(content, "login")
    assert String.contains?(content, "register")
  end

  test "entry for presenter", %{conn: conn} do
    content = render_to_string(Callforpapers.PageView, "index.html", conn: conn, current_user: %User{id: 12, name: "Max", role: "presenter"})

    assert !String.contains?(content, "login")
    assert !String.contains?(content, "register")
  end
end
