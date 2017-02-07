defmodule Callforpapers.CallforpapersTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Cfp

  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 4, year: 2010}, status: "open"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cfp.changeset(%Cfp{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Cfp.changeset(%Cfp{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "open is a valid state" do
    assert Cfp.valid_state?("open")
  end

  test "closed is a valid state" do
    assert Cfp.valid_state?("closed")
  end

  test "Foo is not a valid state" do
    refute Cfp.valid_state?("Foo")
  end

  test "valid statis returns valid states" do
    all_valid =
      Cfp.valid_stati
      |> Enum.all?(&Cfp.valid_state?/1)

    assert all_valid
  end

end
