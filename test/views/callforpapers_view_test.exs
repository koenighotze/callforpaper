defmodule Callforpapers.CallforpapersViewTest do
  use Callforpapers.ConnCase, async: true
  import Phoenix.View
  alias Callforpapers.Cfp
  alias Callforpapers.Submission

  @tag login_as: "max"
  @tag :as_organizer
  test "show index with empty cfps", %{conn: conn, user: organizer} do
    content = render_to_string(Callforpapers.CallforpapersView, "index.html", conn: conn, current_user: organizer, callforpapers: [])

    assert String.contains?(content, "Listing callforpapers")
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "a cfp is shown on the index", %{conn: conn, user: organizer} do
    cfp = organizer |> insert_conference |> insert_cfp
    cfp = Repo.get(Cfp, cfp.id) |> Repo.preload(:conference)

    content = render_to_string(Callforpapers.CallforpapersView, "index.html", conn: conn, current_user: organizer, callforpapers: [ cfp ])

    assert String.contains?(content, cfp.conference.title)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "the cfp details are shown", %{conn: conn, user: organizer} do
    cfp = organizer |> insert_conference |> insert_cfp
    cfp = Repo.get(Cfp, cfp.id) |> Repo.preload(:conference)

    content = render_to_string(Callforpapers.CallforpapersView, "show.html", conn: conn, current_user: organizer, cfp: cfp, submissions: [])

    assert String.contains?(content, cfp.conference.title)
    assert String.contains?(content, cfp.start |> to_string)
    assert String.contains?(content, cfp.end |> to_string)
    assert String.contains?(content, cfp.status)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "shown lists all submissions", %{conn: conn, user: organizer} do
    cfp = organizer |> insert_conference |> insert_cfp
    cfp = Repo.get(Cfp, cfp.id) |> Repo.preload(:conference)

    presenter = insert_presenter

    submission =
      presenter
      |> insert_talk
      |> submit_talk(cfp)

    submission =
      Submission
      |> Submission.with_talk
      |> Submission.with_cfp
      |> Repo.get(submission.id)

    content = render_to_string(Callforpapers.CallforpapersView, "show.html", conn: conn, current_user: organizer, cfp: cfp, submissions: [ submission ])

    assert String.contains?(content, presenter.name)
    assert String.contains?(content, submission.submission.title)
    assert String.contains?(content, submission.submission.shortsummary)
    assert String.contains?(content, submission.submission.duration |> to_string)
  end
end