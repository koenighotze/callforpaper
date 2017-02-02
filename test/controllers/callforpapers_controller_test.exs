defmodule Callforpapers.CallforpapersControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.CallforpapersController


  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 4, year: 2010}, status: "open"}
  @invalid_attrs %{}

  @tag login_as: "max"
  @tag :as_organizer
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, callforpapers_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, callforpapers_path(conn, :new)
    assert html_response(conn, 200) =~ "New callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, callforpapers_path(conn, :create), callforpapers: @valid_attrs
    assert redirected_to(conn) == callforpapers_path(conn, :index)
    assert Repo.get_by(Callforpapers, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, callforpapers_path(conn, :create), callforpapers: @invalid_attrs
    assert html_response(conn, 200) =~ "New callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "shows chosen resource", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers.Callforpapers{}
    conn = get conn, callforpapers_path(conn, :show, callforpapers)
    assert html_response(conn, 200) =~ "Show callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, callforpapers_path(conn, :show, -1)
    end
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "renders form for editing chosen resource", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers.Callforpapers{}
    conn = get conn, callforpapers_path(conn, :edit, callforpapers)
    assert html_response(conn, 200) =~ "Edit callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers.Callforpapers{}
    conn = put conn, callforpapers_path(conn, :update, callforpapers), callforpapers: @valid_attrs
    assert redirected_to(conn) == callforpapers_path(conn, :show, callforpapers)
    assert Repo.get_by(Callforpapers, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers.Callforpapers{}
    conn = put conn, callforpapers_path(conn, :update, callforpapers), callforpapers: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "deletes chosen resource", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers.Callforpapers{}
    conn = delete conn, callforpapers_path(conn, :delete, callforpapers)
    assert redirected_to(conn) == callforpapers_path(conn, :index)
    refute Repo.get(Callforpapers.Callforpapers, callforpapers.id)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "load_conferences loads the conferences for the current user", %{conn: conn, user: user} do
    insert_conference(user)

    CallforpapersController.load_conferences(conn, [])

    conferences = Repo.get_by(Callforpapers.Conference, %{user_id: user.id})

    assert conn.assigns[:conferences] == conferences
  end


  @tag login_as: "max"
  @tag :as_organizer
  test "load_conferences returns empty list if no conferences are found", %{conn: conn, user: user} do
    CallforpapersController.load_conferences(conn, [])

    conferences = Repo.get_by(Callforpapers.Conference, %{user_id: user.id})

    assert conn.assigns[:conferences] == []
  end

end
