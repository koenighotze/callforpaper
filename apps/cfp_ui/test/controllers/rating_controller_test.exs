defmodule CfpUi.RatingControllerTest do
  use CfpUi.ConnCase

  alias CfpUi.Rating
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, rating_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing ratings"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, rating_path(conn, :new)
    assert html_response(conn, 200) =~ "New rating"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, rating_path(conn, :create), rating: @valid_attrs
    assert redirected_to(conn) == rating_path(conn, :index)
    assert Repo.get_by(Rating, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, rating_path(conn, :create), rating: @invalid_attrs
    assert html_response(conn, 200) =~ "New rating"
  end

  test "shows chosen resource", %{conn: conn} do
    rating = Repo.insert! %Rating{}
    conn = get conn, rating_path(conn, :show, rating)
    assert html_response(conn, 200) =~ "Show rating"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, rating_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    rating = Repo.insert! %Rating{}
    conn = get conn, rating_path(conn, :edit, rating)
    assert html_response(conn, 200) =~ "Edit rating"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    rating = Repo.insert! %Rating{}
    conn = put conn, rating_path(conn, :update, rating), rating: @valid_attrs
    assert redirected_to(conn) == rating_path(conn, :show, rating)
    assert Repo.get_by(Rating, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    rating = Repo.insert! %Rating{}
    conn = put conn, rating_path(conn, :update, rating), rating: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit rating"
  end

  test "deletes chosen resource", %{conn: conn} do
    rating = Repo.insert! %Rating{}
    conn = delete conn, rating_path(conn, :delete, rating)
    assert redirected_to(conn) == rating_path(conn, :index)
    refute Repo.get(Rating, rating.id)
  end
end
