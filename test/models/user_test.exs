defmodule Callforpapers.UserTest do
  use Callforpapers.ModelCase

  alias Callforpapers.User
  alias Callforpapers.Talk

  @valid_talk_attrs %{duration: 42, shortsummary: "some cadsasddasadsadsadsdasadsadsontent", title: "some content"}
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

  test "add talks adds a talk to the user" do
    presenter = insert_presenter

    talk =
      presenter
      |> User.add_talk(@valid_talk_attrs)
      |> Repo.insert!

    refute talk.id == nil
    assert talk.title == @valid_talk_attrs.title
    assert talk.shortsummary == @valid_talk_attrs.shortsummary

    talks_of_presenter = Repo.all(Talk.talks(presenter))

    assert talk in talks_of_presenter
  end

  test "the talk name must be unique per user" do
    presenter = insert_presenter

    presenter
      |> User.add_talk(@valid_talk_attrs)
      |> Repo.insert!

    invalid_talk =
      presenter
      |> User.add_talk(@valid_talk_attrs)

    assert Dict.has_key? invalid_talk.errors, :title
    refute invalid_talk.valid?
  end

end
