defmodule Callforpapers.TalkController do
  use Callforpapers.Web, :controller
  alias Callforpapers.Talk
  alias Callforpapers.User

  plug :authenticate_user
  plug :load_presenters when action in [:create, :update, :new, :edit]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def load_presenters(conn, _opts) do
    presenters = User
           |> User.alphabetical
           |> User.names_and_ids
           |> User.filter_on_presesenters
           |> Repo.all

    conn
    |> assign(:presenters, presenters)
  end

  def index(conn, _params, current_user) do
    talks =
      current_user
      |> User.talks_by_presenter
      |> Repo.all
    render(conn, "index.html", talks: talks)
  end

  def new(conn, _params, current_user) do
    changeset = Talk.changeset(%Talk{})

    render conn, "new.html", durations: ["Quickie (20 min)", "Presentation (45 min)", "University / Lab (2 h)"], presenter: current_user.name, changeset: changeset
  end

  def create(conn, %{"submission" => params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:submissions)
      |> Talk.changeset(params)

    case Repo.insert(changeset) do
      {:ok, _submission} ->
        conn
        |> put_flash(:info, "Talk created successfully.")
        |> redirect(to: talk_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", durations: [20, 45, 60, 90], presenter: current_user.name, changeset: changeset)
    end
  end

  defp talk_by_id(current_user, id) do
    current_user
      |> User.talks_by_presenter
      |> Repo.get!(id)
  end

  def show(conn, %{"id" => id}, current_user) do
    talk = talk_by_id(current_user, id)
    render(conn, "show.html", talk: talk)
  end

  def edit(conn, %{"id" => id}, current_user) do
    talk = talk_by_id(current_user, id)
    changeset = Talk.changeset(talk)
    render(conn, "edit.html", durations: [20, 45, 60, 90], talk: talk, presenter: current_user.name, changeset: changeset)
  end

  def update(conn, %{"id" => id, "talk" => params}, current_user) do
    talk = talk_by_id(current_user, id)
    changeset = Talk.changeset(talk, params)

    case Repo.update(changeset) do
      {:ok, talk} ->
        conn
        |> put_flash(:info, "Talk updated successfully.")
        |> redirect(to: talk_path(conn, :show, talk))
      {:error, changeset} ->
        render(conn, "edit.html", talk: talk, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    talk = talk_by_id(current_user, id)

    Repo.delete!(talk)

    conn
    |> put_flash(:info, "Talk deleted successfully.")
    |> redirect(to: talk_path(conn, :index))
  end
end