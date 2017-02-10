defmodule Callforpapers.SubmissionControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Submission
  @valid_attrs %{status: "open"}
  @invalid_attrs %{status: "blafasel"}

  @tag login_as: "max"
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, submission_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing submissions"
  end

  @tag login_as: "max"
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, submission_path(conn, :new)
    assert html_response(conn, 200) =~ "New submission"
  end

  @tag login_as: "max"
  test "creates resource and redirects when data is valid", %{conn: conn} do
    cfp = insert_organizer |> insert_conference |> insert_cfp
    talk = insert_presenter |> insert_talk

    conn = post conn, submission_path(conn, :create), submission: Dict.merge(@valid_attrs, cfp_id: cfp.id, submission_id: talk.id)
    assert redirected_to(conn) == submission_path(conn, :index)
    assert Repo.get_by(Submission, @valid_attrs)
  end

  @tag login_as: "max"
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, submission_path(conn, :create), submission: @invalid_attrs
    assert html_response(conn, 200) =~ "New submission"
  end

  @tag login_as: "max"
  test "shows chosen resource", %{conn: conn} do
    filing = Repo.insert! %Submission{}
    conn = get conn, submission_path(conn, :show, filing)
    assert html_response(conn, 200) =~ "Show submission"
  end

  @tag login_as: "max"
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, submission_path(conn, :show, -1)
    end
  end

  @tag login_as: "max"
  test "renders form for editing chosen resource", %{conn: conn} do
    filing = Repo.insert! %Submission{}
    conn = get conn, submission_path(conn, :edit, filing)
    assert html_response(conn, 200) =~ "Edit submission"
  end

  @tag login_as: "max"
  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    cfp = insert_organizer |> insert_conference |> insert_cfp
    talk = insert_presenter |> insert_talk
    filing = Repo.insert! %Submission{cfp_id: cfp.id, submission_id: talk.id}

    conn = put conn, submission_path(conn, :update, filing), submission: @valid_attrs

    assert redirected_to(conn) == submission_path(conn, :show, filing)
    assert Repo.get_by(Submission, @valid_attrs)
  end

  @tag login_as: "max"
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = put conn, submission_path(conn, :update, submission), submission: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit submission"
  end

  @tag login_as: "max"
  test "deletes chosen resource", %{conn: conn} do
    filing = Repo.insert! %Submission{}
    conn = delete conn, submission_path(conn, :delete, filing)
    assert redirected_to(conn) == submission_path(conn, :index)
    refute Repo.get(Submission, filing.id)
  end

  @tag login_as: "max"
  test "presenters cannot accept talks", %{conn: conn} do
    res = post conn, submission_accept_path(conn, :accept, 1)
    assert html_response(res, 404) =~ "Page not found"
  end

  @tag login_as: "max"
  test "presenters cannot reject talks", %{conn: conn} do
    res = post conn, submission_reject_path(conn, :reject, 1)
    assert html_response(res, 404) =~ "Page not found"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "organizers can accept filings", %{conn: conn, user: user} do
    filing = insert_filing(user)

    conn = post conn, submission_accept_path(conn, :accept, filing.id)
    assert redirected_to(conn) == callforpapers_path(conn, :show, filing.cfp_id)

    updated = Repo.get(Submission, filing.id)
    assert Submission.accepted?(updated)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "organizers can reject filings", %{conn: conn, user: user} do
    filing = insert_filing(user)

    conn = post conn, submission_reject_path(conn, :reject, filing.id)
    assert redirected_to(conn) == callforpapers_path(conn, :show, filing.cfp_id)

    updated = Repo.get(Submission, filing.id)
    assert Submission.rejected?(updated)
  end


  @tag login_as: "max"
  @tag :as_organizer
  test "organizers cannot submit talks", %{conn: conn, user: organizer} do
    cfp = organizer |> insert_conference |> insert_cfp
    talk = insert_presenter |> insert_talk
    conn = post conn, submission_path(conn, :create), submission: Dict.merge(@valid_attrs, cfp_id: cfp.id, submission_id: talk.id)
    refute Repo.get_by(Submission, @valid_attrs)

    assert redirected_to(conn) == page_path(conn, :index)
  end
end
