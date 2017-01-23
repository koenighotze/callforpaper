defmodule Callforpapers.PresenterControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Presenter
  @valid_attrs %{bio: "some content", email: "some content", name: "some content", picture: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, presenter_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing presenters"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, presenter_path(conn, :new)
    assert html_response(conn, 200) =~ "New presenter"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, presenter_path(conn, :create), presenter: @valid_attrs
    assert redirected_to(conn) == presenter_path(conn, :index)
    assert Repo.get_by(Presenter, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, presenter_path(conn, :create), presenter: @invalid_attrs
    assert html_response(conn, 200) =~ "New presenter"
  end

  test "shows chosen resource", %{conn: conn} do
    presenter = Repo.insert! %Presenter{}
    conn = get conn, presenter_path(conn, :show, presenter)
    assert html_response(conn, 200) =~ "Show presenter"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, presenter_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    presenter = Repo.insert! %Presenter{}
    conn = get conn, presenter_path(conn, :edit, presenter)
    assert html_response(conn, 200) =~ "Edit presenter"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    presenter = Repo.insert! %Presenter{}
    conn = put conn, presenter_path(conn, :update, presenter), presenter: @valid_attrs
    assert redirected_to(conn) == presenter_path(conn, :show, presenter)
    assert Repo.get_by(Presenter, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    presenter = Repo.insert! %Presenter{}
    conn = put conn, presenter_path(conn, :update, presenter), presenter: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit presenter"
  end

  test "deletes chosen resource", %{conn: conn} do
    presenter = Repo.insert! %Presenter{}
    conn = delete conn, presenter_path(conn, :delete, presenter)
    assert redirected_to(conn) == presenter_path(conn, :index)
    refute Repo.get(Presenter, presenter.id)
  end
end
