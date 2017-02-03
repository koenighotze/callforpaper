defmodule Callforpapers.FilingTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Filing

  @valid_attrs %{status: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Filing.changeset(%Filing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Filing.changeset(%Filing{}, @invalid_attrs)
    refute changeset.valid?
  end
end
