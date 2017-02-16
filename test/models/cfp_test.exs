defmodule Callforpapers.CallforpapersTest do
  use Callforpapers.ModelCase

  alias Callforpapers.Cfp
  alias Ecto.Changeset

  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 3, year: 2010}, status: "open"}
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

  test "a cfp can be assigned to a different conference" do
    organizer = insert_organizer
    conf = organizer |> insert_conference
    other_conf = organizer |> insert_conference(%{title: "another conference"})
    cfp = conf |> insert_cfp

    other_conf
      |> build_assoc(:callforpapers)
      |> Cfp.changeset(%{status: "open"})

    %Cfp{id: cfp.id}
      |> Changeset.change
      |> Changeset.put_assoc(:conference, other_conf)
      |> Repo.update!

    loaded = Repo.get(Cfp, cfp.id)
    assert loaded.conference_id == other_conf.id
  end

  test "update cfp completly" do
    organizer = insert_organizer
    conf = organizer |> insert_conference
    other_conf = organizer |> insert_conference(%{title: "another conference"})
    cfp = conf |> insert_cfp(%{start: ~D{2010-01-01}})

    other_conf
      |> build_assoc(:callforpapers)
      |> Cfp.changeset(%{status: "open"})

    %Cfp{id: cfp.id}
      |> Changeset.change
      |> Changeset.cast(%{start: ~D{2000-10-10}}, [:start, :end, :status])
      |> Changeset.put_assoc(:conference, other_conf)
      |> Repo.update!

    loaded = Repo.get(Cfp, cfp.id)
    assert Ecto.Date.to_erl(loaded.start) == {2000, 10, 10}
  end

  test "the start day must not be the same as the end day" do
    cfp =
      %Cfp{}
      |> Cfp.changeset(%{start: ~D{2000-10-10}, end: ~D{2000-10-10}, status: "open"})

    refute cfp.valid?
  end

  test "the start day must not be after the end day" do
    cfp =
      %Cfp{}
      |> Cfp.changeset(%{start: ~D{2000-10-11}, end: ~D{2000-10-10}, status: "open"})

    refute cfp.valid?
  end

  test "deleting a cfp should cascade to the submissions" do
    cfp = insert_organizer |> insert_conference |> insert_cfp(%{start: ~D{2010-01-01}})
    talk = insert_presenter |> insert_talk

    submission = submit_talk(talk, cfp)

    Repo.delete!(cfp)
    refute Repo.get(Callforpapers.Submission, submission.id)
  end
end
