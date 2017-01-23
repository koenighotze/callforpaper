defmodule CfpUi.PresentationControllerTest do
  use CfpUi.ConnCase

  alias CfpUi.Presentation
  @valid_attrs %{held_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, held_where: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, presentation_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing presentations"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, presentation_path(conn, :new)
    assert html_response(conn, 200) =~ "New presentation"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, presentation_path(conn, :create), presentation: @valid_attrs
    assert redirected_to(conn) == presentation_path(conn, :index)
    assert Repo.get_by(Presentation, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, presentation_path(conn, :create), presentation: @invalid_attrs
    assert html_response(conn, 200) =~ "New presentation"
  end

  test "shows chosen resource", %{conn: conn} do
    presentation = Repo.insert! %Presentation{}
    conn = get conn, presentation_path(conn, :show, presentation)
    assert html_response(conn, 200) =~ "Show presentation"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, presentation_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    presentation = Repo.insert! %Presentation{}
    conn = get conn, presentation_path(conn, :edit, presentation)
    assert html_response(conn, 200) =~ "Edit presentation"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    presentation = Repo.insert! %Presentation{}
    conn = put conn, presentation_path(conn, :update, presentation), presentation: @valid_attrs
    assert redirected_to(conn) == presentation_path(conn, :show, presentation)
    assert Repo.get_by(Presentation, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    presentation = Repo.insert! %Presentation{}
    conn = put conn, presentation_path(conn, :update, presentation), presentation: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit presentation"
  end

  test "deletes chosen resource", %{conn: conn} do
    presentation = Repo.insert! %Presentation{}
    conn = delete conn, presentation_path(conn, :delete, presentation)
    assert redirected_to(conn) == presentation_path(conn, :index)
    refute Repo.get(Presentation, presentation.id)
  end
end
