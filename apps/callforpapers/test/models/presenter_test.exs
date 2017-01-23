defmodule Callforpapers.PresenterTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Presenter

  @valid_attrs %{bio: "some content", email: "some content", name: "some content", picture: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Presenter.changeset(%Presenter{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Presenter.changeset(%Presenter{}, @invalid_attrs)
    refute changeset.valid?
  end
end
