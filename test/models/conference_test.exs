defmodule Callforpapers.ConferenceTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Conference

  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 3, year: 2010}, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Conference.changeset(%Conference{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Conference.changeset(%Conference{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "the start day must not be the same as the end day" do
    conf =
      %Conference{}
      |> Conference.changeset(%{start: ~D{2000-10-10}, end: ~D{2000-10-10}, title: "daadsasdasdasdasdsadadsads"})
    refute conf.valid?
  end

    test "the start day must not be after the end day" do
    conf =
      %Conference{}
      |> Conference.changeset(%{start: ~D{2000-10-11}, end: ~D{2000-10-10}, title: "opadsadsasdadsadsasdasden"})
    refute conf.valid?
  end
end
