defmodule Callforpapers.ConferenceControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Conference
  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 4, year: 2010}, title: "some content"}
  @invalid_attrs %{}

  @tag login_as: "max"
  @tag :as_organizer
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, conference_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing conferences"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, conference_path(conn, :new)
    assert html_response(conn, 200) =~ "New conference"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, conference_path(conn, :create), conference: @valid_attrs
    assert redirected_to(conn) == conference_path(conn, :index)
    assert Repo.get_by(Conference, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, conference_path(conn, :create), conference: @invalid_attrs
    assert html_response(conn, 200) =~ "New conference"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "shows chosen resource", %{conn: conn} do
    conference = Repo.insert! %Conference{} |> Conference.changeset(@valid_attrs)
    conn = get conn, conference_path(conn, :show, conference)
    assert html_response(conn, 200) =~ "Show conference"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, conference_path(conn, :show, -1)
    end
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "renders form for editing chosen resource", %{conn: conn} do
    conference = Repo.insert! %Conference{}
    conn = get conn, conference_path(conn, :edit, conference)
    assert html_response(conn, 200) =~ "Edit conference"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    conference = Repo.insert! %Conference{}
    conn = put conn, conference_path(conn, :update, conference), conference: @valid_attrs
    assert redirected_to(conn) == conference_path(conn, :show, conference)
    assert Repo.get_by(Conference, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conference = Repo.insert! %Conference{}
    conn = put conn, conference_path(conn, :update, conference), conference: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit conference"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "deletes chosen resource", %{conn: conn} do
    conference = Repo.insert! %Conference{} |> Conference.changeset(@valid_attrs)
    conn = delete conn, conference_path(conn, :delete, conference)
    assert redirected_to(conn) == conference_path(conn, :index)
    refute Repo.get(Conference, conference.id)
  end

  @tag login_as: "max"
  test "presenters cannot modify conferences", %{conn: conn} do
    conference = Repo.insert! %Conference{} |> Conference.changeset(@valid_attrs)
    conn = put conn, conference_path(conn, :update, conference), conference: %{title: "foo"}
    assert html_response(conn, 404)
    assert Repo.get_by!(Conference, @valid_attrs)
  end

  @tag login_as: "max"
  test "presenters cannot delete conferences", %{conn: conn} do
    conference = Repo.insert! %Conference{} |> Conference.changeset(@valid_attrs)
    conn = delete conn, conference_path(conn, :delete, conference)
    assert html_response(conn, 404)
    assert Repo.get(Conference, conference.id)
  end

  @tag login_as: "max"
  test "presenters can view all conferences", %{conn: conn} do
    conn = get conn, conference_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing conferences"
  end

  @tag login_as: "max"
  test "presenters can view conference details", %{conn: conn} do
    conference = Repo.insert! %Conference{} |> Conference.changeset(@valid_attrs)
    conn = get conn, conference_path(conn, :show, conference)
    assert html_response(conn, 200) =~ "Show conference"
  end
end
