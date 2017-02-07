defmodule Callforpapers.TalkControllerTest do
  use Callforpapers.ConnCase

  alias Callforpapers.Talk
  alias Callforpapers.TalkController

  @valid_attrs %{duration: 42, shortsummary: "some cadsasddasadsadsadsdasadsadsontent", title: "some content"}
  @invalid_attrs %{shortsummary: "too short"}

  @tag login_as: "max"
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, talk_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing talks"
  end

  @tag login_as: "max"
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, talk_path(conn, :new)
    assert html_response(conn, 200) =~ "New talk"
  end

  @tag login_as: "max"
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, talk_path(conn, :create), submission: @valid_attrs
    assert redirected_to(conn) == talk_path(conn, :index)
    assert Repo.get_by(Talk, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :skip # figure out how to provide for assigns
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, talk_path(conn, :create), submission: @invalid_attrs
    assert html_response(conn, 200) =~ "New talk"
  end

  @tag login_as: "max"
  test "shows chosen resource", %{conn: conn, user: user} do
    submission = insert_valid_submission(user)
    conn = get conn, talk_path(conn, :show, submission)
    assert html_response(conn, 200) =~ "Show talk"
  end

  @tag login_as: "max"
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, talk_path(conn, :show, -1)
    end
  end

  @tag login_as: "max"
  @tag :skip # Try to prefetch assign for @presenters
  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    submission = insert_valid_submission(user)

    conn = TalkController.load_presenters(conn, [])

    conn = get conn, talk_path(conn, :edit, submission)
    assert html_response(conn, 200) =~ "Edit talk"
  end

  @tag login_as: "max"
  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    update = %{externallink: "some content"}

    submission = insert_valid_submission(user)

    conn = put conn, talk_path(conn, :update, submission), submission: update
    assert redirected_to(conn) == talk_path(conn, :show, submission)
    assert Repo.get_by(Talk, Map.merge(@valid_attrs, update))
  end

  @tag login_as: "max"
  @tag :skip
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    submission = insert_valid_submission(user)

    conn = TalkController.load_presenters(conn, [])

    IO.puts "#{inspect conn}"
    conn = put conn, talk_path(conn, :update, submission), submission: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit talk"
  end

  @tag login_as: "max"
  test "deletes chosen resource", %{conn: conn, user: user} do
    submission = insert_valid_submission(user)
    conn = delete conn, talk_path(conn, :delete, submission)
    assert redirected_to(conn) == talk_path(conn, :index)
    refute Repo.get(Talk, submission.id)
  end

  @tag login_as: "max"
  test "submissions are created for the currently loged in user", %{conn: conn} do
    conn = post conn, talk_path(conn, :create), submission: @valid_attrs
    assert redirected_to(conn) == talk_path(conn, :index)

    submission =
      Talk
      |> Talk.with_presenter
      |> Repo.get_by!(@valid_attrs)

    assert submission.user.name == "max"
  end

  @tag login_as: "max"
  test "with_presenter fetches the presenter", %{user: user} do
    submission = Callforpapers.TestHelpers.insert_submission(user)

    found =
      Talk
      |> Talk.with_presenter
      |> Repo.get!(submission.id)

    assert found.user.name == "max"
  end

  defp insert_valid_submission(user) do
    changeset =
      user
      |> build_assoc(:submissions)
      |> Talk.changeset(@valid_attrs)
    Repo.insert! changeset
  end
end
