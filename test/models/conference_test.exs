defmodule Callforpapers.ConferenceTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Conference

  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 4, year: 2010}, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Conference.changeset(%Conference{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Conference.changeset(%Conference{}, @invalid_attrs)
    refute changeset.valid?
  end
end
