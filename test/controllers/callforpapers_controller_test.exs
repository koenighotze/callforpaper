defmodule Callforpapers.CallforpapersControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.CallforpapersController
  alias Callforpapers.Conference
  alias Callforpapers.Cfp

  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 3, year: 2010}, status: "open"}
  @invalid_attrs %{start: nil}

  @tag login_as: "max"
  test "lists all entries on index for simple user", %{conn: conn} do
    conn = get conn, callforpapers_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "lists all entries on index for organizer", %{conn: conn} do
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
  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conference = user |> insert_conference
    conn = post conn, callforpapers_path(conn, :create), cfp: Dict.merge(%{conference_id: conference.id}, @valid_attrs)
    assert redirected_to(conn) == callforpapers_path(conn, :index)
    assert Repo.get_by(Cfp, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conference = user |> insert_conference
    conn = post conn, callforpapers_path(conn, :create), cfp: Dict.merge(%{conference_id: conference.id}, @invalid_attrs)
    assert html_response(conn, 200) =~ "New callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "shows chosen resource", %{conn: conn, user: user} do
    callforpapers = user |> insert_conference |> insert_cfp
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
  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    callforpapers = user |> insert_conference |> insert_cfp
    conn = get conn, callforpapers_path(conn, :edit, callforpapers)
    assert html_response(conn, 200) =~ "Edit callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    callforpapers = user |> insert_conference |> insert_cfp

    conn = put conn, callforpapers_path(conn, :update, callforpapers), cfp: @valid_attrs
    assert redirected_to(conn) == callforpapers_path(conn, :show, callforpapers)
    assert Repo.get_by(Cfp, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    callforpapers = user |> insert_conference |> insert_cfp
    conn = put conn, callforpapers_path(conn, :update, callforpapers), cfp: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit callforpapers"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "deletes chosen resource", %{conn: conn} do
    callforpapers = Repo.insert! %Cfp{}
    conn = delete conn, callforpapers_path(conn, :delete, callforpapers)
    assert redirected_to(conn) == callforpapers_path(conn, :index)
    refute Repo.get(Cfp, callforpapers.id)
  end

  @tag login_as: "max"
  @tag :as_organizer
  @tag :skip # check how to test assign
  test "load_conferences loads the conferences for the current user", %{conn: conn, user: user} do
    insert_conference(user)

    CallforpapersController.load_conferences(conn, [])

    conferences = Repo.get_by(Conference, %{user_id: user.id})

    assert conn.assigns[:conferences] == conferences
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "load_conferences returns nil if no conferences are found", %{conn: conn} do
    CallforpapersController.load_conferences(conn, [])

    assert conn.assigns[:conferences] == nil
  end

  @tag login_as: "max"
  test "presenters cannot create cfps", %{conn: conn} do
    conn = get conn, callforpapers_path(conn, :new)
    assert html_response(conn, 404)
  end

  @tag login_as: "max"
  test "presenters cannot modify cfps", %{conn: conn, user: presenter} do
    callforpapers = presenter |> insert_conference |> insert_cfp
    conn = put conn, callforpapers_path(conn, :update, callforpapers), cfp: @valid_attrs

    assert html_response(conn, 404)
  end

  @tag login_as: "max"
  test "presenters cannot delete cfps", %{conn: conn, user: presenter} do
    callforpapers = presenter |> insert_conference |> insert_cfp
    conn = delete conn, callforpapers_path(conn, :delete, callforpapers)
    assert html_response(conn, 404)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "open opens a cfp", %{conn: conn, user: organizer} do
    callforpapers = organizer |> insert_conference |> insert_cfp(%{status: "closed"})

    conn = put conn, callforpapers_open_path(conn, :open, callforpapers)

    assert redirected_to(conn) == callforpapers_path(conn, :index)
    opened_cfp = Repo.get(Cfp, callforpapers.id)
    assert get_flash(conn, :info) =~ "Callforpapers opened successfully."
    assert opened_cfp.status == "open"
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "close closes a cfp", %{conn: conn, user: organizer} do
    callforpapers = organizer |> insert_conference |> insert_cfp(%{status: "open"})

    conn = put conn, callforpapers_close_path(conn, :close, callforpapers)

    assert redirected_to(conn) == callforpapers_path(conn, :index)
    opened_cfp = Repo.get(Cfp, callforpapers.id)
    assert get_flash(conn, :info) =~ "Callforpapers closed successfully."
    assert opened_cfp.status == "closed"
  end
end
