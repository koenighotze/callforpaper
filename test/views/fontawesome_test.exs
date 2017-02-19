defmodule Callforpapers.FontAwesomeTest do
  use ExUnit.Case, async: true
  import Callforpapers.FontAwesome

  test "renders the fixed width icon" do
    {:safe, result}
      = fw_icon("foo")

    assert to_string(result) == "<i class=\"fa fa-foo fa-fw\"></i>"
  end

  test "passes additional params to the fontawesome lib" do
    {:safe, result}
      = fw_icon("foo", class: "bar", data: [mood: :happy])

    assert to_string(result) == "<i class=\"fa fa-foo fa-fw\" data-mood=\"happy\"></i>"
  end
end
