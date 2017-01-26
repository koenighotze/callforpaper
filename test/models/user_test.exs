defmodule Callforpapers.UserTest do
  use Callforpapers.ModelCase

  alias Callforpapers.User

  @valid_attrs %{bio: "some content", email: "some content", name: "some content", picture: "some content", role: "presenter"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "the role must be either presenter or organizer" do
    changeset = User.changeset(%User{}, Map.put(@valid_attrs, :role, "Hullewu"))
    refute changeset.valid?
  end

  test "presenters are presenters" do
    assert User.is_presenter? %User{role: "presenter"}
  end

  test "presenters are not organizers" do
    refute User.is_organizer? %User{role: "presenter"}
  end

end
