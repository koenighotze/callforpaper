defmodule Callforpapers.CallforpapersControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Callforpapers
  @valid_attrs %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 4, year: 2010}, status: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, callforpapers_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing callforpapers"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, callforpapers_path(conn, :new)
    assert html_response(conn, 200) =~ "New callforpapers"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, callforpapers_path(conn, :create), callforpapers: @valid_attrs
    assert redirected_to(conn) == callforpapers_path(conn, :index)
    assert Repo.get_by(Callforpapers, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, callforpapers_path(conn, :create), callforpapers: @invalid_attrs
    assert html_response(conn, 200) =~ "New callforpapers"
  end

  test "shows chosen resource", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers{}
    conn = get conn, callforpapers_path(conn, :show, callforpapers)
    assert html_response(conn, 200) =~ "Show callforpapers"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, callforpapers_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers{}
    conn = get conn, callforpapers_path(conn, :edit, callforpapers)
    assert html_response(conn, 200) =~ "Edit callforpapers"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers{}
    conn = put conn, callforpapers_path(conn, :update, callforpapers), callforpapers: @valid_attrs
    assert redirected_to(conn) == callforpapers_path(conn, :show, callforpapers)
    assert Repo.get_by(Callforpapers, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers{}
    conn = put conn, callforpapers_path(conn, :update, callforpapers), callforpapers: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit callforpapers"
  end

  test "deletes chosen resource", %{conn: conn} do
    callforpapers = Repo.insert! %Callforpapers{}
    conn = delete conn, callforpapers_path(conn, :delete, callforpapers)
    assert redirected_to(conn) == callforpapers_path(conn, :index)
    refute Repo.get(Callforpapers, callforpapers.id)
  end
end
