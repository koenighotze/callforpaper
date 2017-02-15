defmodule Callforpapers.SubmissionTest do
  use Callforpapers.ModelCase, async: true
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

  test "cfp_id is mandatory" do
    changeset = Submission.changeset(%Submission{}, Dict.delete(@valid_attrs, :cfp_id))
    refute changeset.valid?
  end

  test "submission_id is mandatory" do
    changeset = Submission.changeset(%Submission{}, Dict.delete(@valid_attrs, :submission_id))
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

  defp prepare_submission do
    cfp = insert_organizer |> insert_conference |> insert_cfp
    presenter = insert_presenter
    talk = presenter |> insert_talk
    submission = %Submission{submission_id: talk.id, cfp_id: cfp.id} |> Repo.insert!
    submission = Submission.with_talk(Submission) |> Repo.get(submission.id)

    %{cfp: cfp, presenter: presenter, talk: talk, submission: submission}
  end

  test "presenter returns the presenter of the talk" do
    %{presenter: presenter, submission: submission} = prepare_submission

    assert Submission.presenter(submission) == presenter.name
  end

  test "title returns the presenter of the talk" do
    %{submission: submission, talk: talk} = prepare_submission

    assert Submission.title(submission) == talk.title

  end
end
