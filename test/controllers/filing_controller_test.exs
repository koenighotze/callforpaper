defmodule Callforpapers.FilingControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Filing
  @valid_attrs %{status: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, filing_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing filings"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, filing_path(conn, :new)
    assert html_response(conn, 200) =~ "New filing"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, filing_path(conn, :create), filing: @valid_attrs
    assert redirected_to(conn) == filing_path(conn, :index)
    assert Repo.get_by(Filing, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, filing_path(conn, :create), filing: @invalid_attrs
    assert html_response(conn, 200) =~ "New filing"
  end

  test "shows chosen resource", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = get conn, filing_path(conn, :show, filing)
    assert html_response(conn, 200) =~ "Show filing"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, filing_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = get conn, filing_path(conn, :edit, filing)
    assert html_response(conn, 200) =~ "Edit filing"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = put conn, filing_path(conn, :update, filing), filing: @valid_attrs
    assert redirected_to(conn) == filing_path(conn, :show, filing)
    assert Repo.get_by(Filing, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = put conn, filing_path(conn, :update, filing), filing: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit filing"
  end

  test "deletes chosen resource", %{conn: conn} do
    filing = Repo.insert! %Filing{}
    conn = delete conn, filing_path(conn, :delete, filing)
    assert redirected_to(conn) == filing_path(conn, :index)
    refute Repo.get(Filing, filing.id)
  end
end
