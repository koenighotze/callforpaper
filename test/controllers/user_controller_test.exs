defmodule Callforpapers.UserControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.User
  @valid_attrs %{bio: "some content", email: "some content", name: "some content", picture: "some content", role: "presenter"}
  @invalid_attrs %{email: ""}

  @tag login_as: "max"
  @tag :as_organizer
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates the user and redirects to the home page if valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)

    get_flash(conn, :info) =~ "User created successfully. Please log is using your credentials"

    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  @tag login_as: "max"
  test "shows chosen resource", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  @tag login_as: "max"
  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, user_path(conn, :show, -1)
    assert 404 == conn.status
  end

  @tag login_as: "max"
  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  @tag login_as: "max"
  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    presenter = Repo.insert! %User{} |> User.changeset(@valid_attrs)
    conn = put conn, user_path(conn, :update, presenter), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user"
  end

  @tag login_as: "max"
  test "deletes chosen resource", %{conn: conn, user: user} do
    # presenter = Repo.insert! %User{} |> Presenter.changeset(@valid_attrs)
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == page_path(conn, :index)
    refute Repo.get(User, user.id)
  end

  @tag login_as: "max"
  test "presenters cannot view the presenter list", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert conn.status == 404
  end

  @tag login_as: "max"
  test "other presenters's details cannot be viewed by a presenter", %{conn: conn} do
    presenter = Repo.insert! %User{} |> User.changeset(@valid_attrs)
    conn = get conn, user_path(conn, :show, presenter)
    assert conn.status == 404
  end

  @tag login_as: "max"
  test "other presenters's details cannot be edited by a presenter", %{conn: conn} do
    presenter = Repo.insert! %User{} |> User.changeset(@valid_attrs)
    conn = get conn, user_path(conn, :edit, presenter)
    assert conn.status == 404
  end

  @tag login_as: "max"
  test "other presenters's details cannot be deleted by a presenter", %{conn: conn} do
    presenter = Repo.insert! %User{} |> User.changeset(@valid_attrs)
    conn = delete conn, user_path(conn, :delete, presenter)
    assert conn.status == 404
    assert Repo.get(User, presenter.id)
  end

  @tag login_as: "max"
  test "the navigating 'back' link is not shown", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)
    refute html_response(conn, 200) =~ "Back</a>"
  end


  @tag login_as: "max"
  @tag :as_organizer
  test "the navigating 'back' link is shown if organizer", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Back</a>"
  end
end
