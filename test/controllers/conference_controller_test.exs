defmodule Callforpapers.ConferenceControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Conference
  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 4, year: 2010}, title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, conference_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing conferences"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, conference_path(conn, :new)
    assert html_response(conn, 200) =~ "New conference"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, conference_path(conn, :create), conference: @valid_attrs
    assert redirected_to(conn) == conference_path(conn, :index)
    assert Repo.get_by(Conference, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, conference_path(conn, :create), conference: @invalid_attrs
    assert html_response(conn, 200) =~ "New conference"
  end

  test "shows chosen resource", %{conn: conn} do
    conference = Repo.insert! %Conference{}
    conn = get conn, conference_path(conn, :show, conference)
    assert html_response(conn, 200) =~ "Show conference"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, conference_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    conference = Repo.insert! %Conference{}
    conn = get conn, conference_path(conn, :edit, conference)
    assert html_response(conn, 200) =~ "Edit conference"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    conference = Repo.insert! %Conference{}
    conn = put conn, conference_path(conn, :update, conference), conference: @valid_attrs
    assert redirected_to(conn) == conference_path(conn, :show, conference)
    assert Repo.get_by(Conference, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conference = Repo.insert! %Conference{}
    conn = put conn, conference_path(conn, :update, conference), conference: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit conference"
  end

  test "deletes chosen resource", %{conn: conn} do
    conference = Repo.insert! %Conference{}
    conn = delete conn, conference_path(conn, :delete, conference)
    assert redirected_to(conn) == conference_path(conn, :index)
    refute Repo.get(Conference, conference.id)
  end

  test "presenters cannot acces the conference", %{conn: conn} do
    # todo
  end
end
