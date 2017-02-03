defmodule Callforpapers.FilingTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Filing

  @valid_attrs %{status: "open"}
  @invalid_attrs %{status: "ads"}

  test "changeset with valid attributes" do
    changeset = Filing.changeset(%Filing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Filing.changeset(%Filing{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "initially the state of a filing is open" do
    filing = %Filing{}

    assert filing.status == "open"
  end

  test "only open accepted rejected are valid states" do
    assert ~w(open rejected accepted) == Filing.valid_states
  end
end
