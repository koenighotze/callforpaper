defmodule Callforpapers.SubmissionTest do
  use Callforpapers.ModelCase
  import Callforpapers.TestHelpers
  alias Callforpapers.Submission

  alias Callforpapers.Repo

  @valid_attrs %{status: "open", cfp_id: 1, submission_id: 3}
  @invalid_attrs %{status: "ads"}

  test "changeset with valid attributes" do
    changeset = Submission.changeset(%Submission{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Submission.changeset(%Submission{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "initially the state of a Submission is open" do
    filing = %Submission{}

    assert filing.status == "open"
  end

  test "only open accepted rejected are valid states" do
    assert ~w(open rejected accepted) == Submission.valid_states
  end

  test "with_talk preloads the talk" do
    insert_organizer |> insert_conference
    submission = insert_presenter |> insert_talk

    r = %Submission{submission_id: submission.id} |> Repo.insert!

    found = Submission |> Submission.with_talk |> Repo.get(r.id)

    assert found.submission.title == submission.title
  end

  test "with_cfp preloads the cfp and conference" do
    cfp = insert_organizer |> insert_conference |> insert_cfp

    r = %Submission{cfp_id: cfp.id} |> Repo.insert!

    found = Submission |> Submission.with_cfp |> Repo.get(r.id)

    assert found.cfp.start == cfp.start
    assert found.cfp.conference.title != ""
  end
end
