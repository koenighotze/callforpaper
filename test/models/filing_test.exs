defmodule Callforpapers.FilingTest do
  use Callforpapers.ModelCase
  import Callforpapers.TestHelpers
  alias Callforpapers.Filing

  alias Callforpapers.Repo

  @valid_attrs %{status: "open"}
  @invalid_attrs %{status: "ads"}

  test "changeset with valid attributes" do
    changeset = Filing.changeset(%Filing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Filing.changeset(%Filing{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "initially the state of a filing is open" do
    filing = %Filing{}

    assert filing.status == "open"
  end

  test "only open accepted rejected are valid states" do
    assert ~w(open rejected accepted) == Filing.valid_states
  end

  test "with_submission preloads the submission" do
    insert_organizer |> insert_conference
    submission = insert_presenter |> insert_submission

    r = %Filing{submission_id: submission.id} |> Repo.insert!

    found = Filing |> Filing.with_submission |> Repo.get(r.id)

    assert found.submission.title == submission.title
  end

  test "with_cfp preloads the cfp and conference" do
    cfp = insert_organizer |> insert_conference |> insert_cfp

    r = %Filing{cfp_id: cfp.id} |> Repo.insert!

    found = Filing |> Filing.with_cfp |> Repo.get(r.id)

    assert found.cfp.start == cfp.start
    assert found.cfp.conference.title != ""
  end
end
