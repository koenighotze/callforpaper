defmodule CfpUi.PresentationTest do
  use CfpUi.ModelCase

  alias CfpUi.Presentation

  @valid_attrs %{held_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, held_where: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Presentation.changeset(%Presentation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Presentation.changeset(%Presentation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
