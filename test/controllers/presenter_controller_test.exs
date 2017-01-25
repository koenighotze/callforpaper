defmodule Callforpapers.PresenterControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Presenter
  @valid_attrs %{bio: "some content", email: "some content", name: "some content", picture: "some content", role: "presenter"}
  @invalid_attrs %{email: ""}

  @tag login_as: "max"
  @tag :as_organizer
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, presenter_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing presenters"
  end

  @tag login_as: "max"
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, presenter_path(conn, :new)
    assert html_response(conn, 200) =~ "New presenter"
  end

  @tag login_as: "max"
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, presenter_path(conn, :create), presenter: @valid_attrs
    assert redirected_to(conn) == presenter_path(conn, :index)
    assert Repo.get_by(Presenter, @valid_attrs)
  end

  @tag login_as: "max"
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, presenter_path(conn, :create), presenter: @invalid_attrs
    assert html_response(conn, 200) =~ "New presenter"
  end

  @tag login_as: "max"
  test "shows chosen resource", %{conn: conn, user: user} do
    conn = get conn, presenter_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show presenter"
  end

  @tag login_as: "max"
  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, presenter_path(conn, :show, -1)
    assert 404 == conn.status
  end

  @tag login_as: "max"
  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    conn = get conn, presenter_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit presenter"
  end

  @tag login_as: "max"
  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = put conn, presenter_path(conn, :update, user), presenter: @valid_attrs
    assert redirected_to(conn) == presenter_path(conn, :show, user)
    assert Repo.get_by(Presenter, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    presenter = Repo.insert! %Presenter{} |> Presenter.changeset(@valid_attrs)
    conn = put conn, presenter_path(conn, :update, presenter), presenter: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit presenter"
  end

  @tag login_as: "max"
  test "deletes chosen resource", %{conn: conn, user: user} do
    # presenter = Repo.insert! %Presenter{} |> Presenter.changeset(@valid_attrs)
    conn = delete conn, presenter_path(conn, :delete, user)
    assert redirected_to(conn) == page_path(conn, :index)
    refute Repo.get(Presenter, user.id)
  end

  @tag login_as: "max"
  test "presenters cannot view the presenter list", %{conn: conn} do
    conn = get conn, presenter_path(conn, :index)
    assert conn.status == 404
  end

  @tag login_as: "max"
  test "other presenters's details cannot be viewed by a presenter", %{conn: conn} do
    presenter = Repo.insert! %Presenter{} |> Presenter.changeset(@valid_attrs)
    conn = get conn, presenter_path(conn, :show, presenter)
    assert conn.status == 404
  end

  @tag login_as: "max"
  test "other presenters's details cannot be edited by a presenter", %{conn: conn} do
    presenter = Repo.insert! %Presenter{} |> Presenter.changeset(@valid_attrs)
    conn = get conn, presenter_path(conn, :edit, presenter)
    assert conn.status == 404
  end

  @tag login_as: "max"
  test "other presenters's details cannot be deleted by a presenter", %{conn: conn} do
    presenter = Repo.insert! %Presenter{} |> Presenter.changeset(@valid_attrs)
    conn = delete conn, presenter_path(conn, :delete, presenter)
    assert conn.status == 404
    assert Repo.get(Presenter, presenter.id)
  end
end
