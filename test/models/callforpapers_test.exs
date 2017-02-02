defmodule Callforpapers.CallforpapersTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Callforpapers

  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 4, year: 2010}, status: "open"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Callforpapers.changeset(%Callforpapers{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Callforpapers.changeset(%Callforpapers{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "open is a valid state" do
    assert Callforpapers.valid_state?("open")
  end

  test "closed is a valid state" do
    assert Callforpapers.valid_state?("closed")
  end

  test "Foo is not a valid state" do
    refute Callforpapers.valid_state?("Foo")
  end

  test "valid statis returns valid states" do
    all_valid =
      Callforpapers.valid_stati
      |> Enum.all?(&Callforpapers.valid_state?/1)

    assert all_valid
  end

  test "titles_and_ids returns titles and ids" do
    Repo.all(Callforpapers.titles_and_ids(Callforpapers))
  end

  test "filter_on_organizer only returns only the organizers confs" do
    refute true
  end
end
