defmodule Callforpapers.PresenterTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Presenter

  @valid_attrs %{bio: "some content", email: "some content", name: "some content", picture: "some content", role: "presenter"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Presenter.changeset(%Presenter{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Presenter.changeset(%Presenter{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "the role must be either presenter or organizer" do
    changeset = Presenter.changeset(%Presenter{}, Map.put(@valid_attrs, :role, "Hullewu"))
    refute changeset.valid?
  end

  test "presenters are presenters" do
    assert Presenter.is_presenter? %Presenter{role: "presenter"}
  end

  test "presenters are not organizers" do
    refute Presenter.is_organizer? %Presenter{role: "presenter"}
  end

end
