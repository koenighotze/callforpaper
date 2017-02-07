defmodule Callforpapers.FilingControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Filing
  @valid_attrs %{status: "open"}
  @invalid_attrs %{status: "blafasel"}

  @tag login_as: "max"
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, filing_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing filings"
  end

  @tag login_as: "max"
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, filing_path(conn, :new)
    assert html_response(conn, 200) =~ "New filing"
  end

  @tag login_as: "max"
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, filing_path(conn, :create), filing: @valid_attrs
    assert redirected_to(conn) == filing_path(conn, :index)
    assert Repo.get_by(Filing, @valid_attrs)
  end

  @tag login_as: "max"
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, filing_path(conn, :create), filing: @invalid_attrs
    assert html_response(conn, 200) =~ "New filing"
  end

  @tag login_as: "max"
  test "shows chosen resource", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = get conn, filing_path(conn, :show, filing)
    assert html_response(conn, 200) =~ "Show filing"
  end

  @tag login_as: "max"
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, filing_path(conn, :show, -1)
    end
  end

  @tag login_as: "max"
  test "renders form for editing chosen resource", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = get conn, filing_path(conn, :edit, filing)
    assert html_response(conn, 200) =~ "Edit filing"
  end

  @tag login_as: "max"
  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = put conn, filing_path(conn, :update, filing), filing: @valid_attrs
    assert redirected_to(conn) == filing_path(conn, :show, filing)
    assert Repo.get_by(Filing, @valid_attrs)
  end

  @tag login_as: "max"
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = put conn, filing_path(conn, :update, filing), filing: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit filing"
  end

  @tag login_as: "max"
  test "deletes chosen resource", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = delete conn, filing_path(conn, :delete, filing)
    assert redirected_to(conn) == filing_path(conn, :index)
    refute Repo.get(Filing, filing.id)
  end

  @tag login_as: "max"
  test "presenters cannot accept talks", %{conn: conn} do
    res = post conn, filing_accept_path(conn, :accept, 1)
    assert html_response(res, 404) =~ "Page not found"
  end

  @tag login_as: "max"
  test "presenters cannot reject talks", %{conn: conn} do
    res = post conn, filing_reject_path(conn, :reject, 1)
    assert html_response(res, 404) =~ "Page not found"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "organizers can accept filings", %{conn: conn, user: user} do
    filing = insert_filing(user)

    conn = post conn, filing_accept_path(conn, :accept, filing.id)
    assert redirected_to(conn) == callforpapers_path(conn, :show, filing.cfp_id)

    updated = Repo.get(Filing, filing.id)
    assert Filing.accepted?(updated)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "organizers can reject filings", %{conn: conn, user: user} do
    filing = insert_filing(user)

    conn = post conn, filing_reject_path(conn, :reject, filing.id)
    assert redirected_to(conn) == callforpapers_path(conn, :show, filing.cfp_id)

    updated = Repo.get(Filing, filing.id)
    assert Filing.rejected?(updated)
  end

  defp insert_filing(organizer) do
    presenter = insert_presenter
    submission = insert_submission(presenter)
    callforpapers = organizer |> insert_conference |> insert_cfp
    Repo.insert! %Filing{submission_id: submission.id, cfp_id: callforpapers.id}
  end

  # Tests:
  #  Filing only visible to each user
  #  Filing may be retracted
  #  done Filing is initially in state open
  #  done State may only be open, accepted, rejected
  #
  #  Organizer:
  #  may rejected, accept filing
  #  may view all filings for a cfp
  #
end
