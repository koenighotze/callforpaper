defmodule Callforpapers.ConferenceViewTest do
  use Callforpapers.ConnCase, async: true
  import Phoenix.View

  @tag login_as: "max"
  @tag :as_organizer
  test "show index", %{conn: conn, user: presenter} do
    content = render_to_string(Callforpapers.ConferenceView, "index.html", conn: conn, current_user: presenter, conferences: [])

    assert String.contains?(content, "Listing conferences")
  end

end