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
    conn = post conn, talk_path(conn, :create), talk: @valid_attrs
    assert redirected_to(conn) == talk_path(conn, :index)
    assert Repo.get_by(Talk, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :skip # figure out how to provide for assigns
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, talk_path(conn, :create), talk: @invalid_attrs
    assert html_response(conn, 200) =~ "New talk"
  end

  @tag login_as: "max"
  test "shows chosen resource", %{conn: conn, user: user} do
    submission = insert_valid_talk(user)
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
    submission = insert_valid_talk(user)

    conn = TalkController.load_presenters(conn, [])

    conn = get conn, talk_path(conn, :edit, submission)
    assert html_response(conn, 200) =~ "Edit talk"
  end

  @tag login_as: "max"
  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    update = %{externallink: "some content"}

    talk = insert_valid_talk(user)

    conn = put conn, talk_path(conn, :update, talk), talk: update
    assert redirected_to(conn) == talk_path(conn, :show, talk)
    assert Repo.get_by(Talk, Map.merge(@valid_attrs, update))
  end

  @tag login_as: "max"
  @tag :skip
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    submission = insert_valid_talk(user)

    conn = TalkController.load_presenters(conn, [])

    conn = put conn, talk_path(conn, :update, submission), talk: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit talk"
  end

  @tag login_as: "max"
  test "deletes chosen resource", %{conn: conn, user: user} do
    submission = insert_valid_talk(user)
    conn = delete conn, talk_path(conn, :delete, submission)
    assert redirected_to(conn) == talk_path(conn, :index)
    refute Repo.get(Talk, submission.id)
  end

  @tag login_as: "max"
  test "submissions are created for the currently loged in user", %{conn: conn} do
    conn = post conn, talk_path(conn, :create), talk: @valid_attrs
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

  @tag login_as: "max"
  @tag :as_organizer
  test "organizers cannot add talks", %{conn: conn} do
    conn = post conn, talk_path(conn, :create), talk: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)

    refute Repo.get_by(Talk, @valid_attrs)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "organizers cannot delete talks", %{conn: conn, user: organizer} do
    talk = insert_valid_talk(organizer)
    conn = delete conn, talk_path(conn, :delete, talk)
    assert redirected_to(conn) == page_path(conn, :index)
  end

  @tag login_as: "max"
  @tag :as_organizer
  test "organizers cannot modify talks", %{conn: conn, user: organizer} do
    talk = insert_valid_talk(organizer)
    conn = delete conn, talk_path(conn, :delete, talk)
    assert redirected_to(conn) == page_path(conn, :index)
  end

  @tag login_as: "max"
  test "talk with user returns talk only if user matches", %{user: presenter} do
    orga = insert_organizer
    inserted_talk = insert_valid_talk(presenter)
    loaded_talk = TalkController.talk_by_user(presenter, inserted_talk.id)
    assert loaded_talk == inserted_talk
    assert catch_error(TalkController.talk_by_user(orga, inserted_talk.id))
  end

  @tag login_as: "max"
  test "talk titles must be unique per presenter", %{conn: conn, user: presenter} do
    talk = presenter |> insert_valid_talk

    conn = post conn, talk_path(conn, :create), talk: Dict.merge(@invalid_attrs, %{title: talk.title})
    assert html_response(conn, 200) =~ "New talk"
  end

  defp insert_valid_talk(user) do
    changeset =
      user
      |> build_assoc(:talks)
      |> Talk.changeset(@valid_attrs)
    Repo.insert! changeset
  end
end
